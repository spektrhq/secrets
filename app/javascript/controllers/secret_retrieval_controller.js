import { Controller } from "@hotwired/stimulus"
import { hex, hex2ArrayBuffer } from "../utils"

export default class extends Controller {
  static targets = [ "content", "iv", "key", "secret", "form" ]

  async decrypt() {
    let ciphertext = hex2ArrayBuffer(this.contentTarget.value)
    let key = await this.importSecretKey(hex2ArrayBuffer(this.keyTarget.value))
    let iv = hex2ArrayBuffer(this.ivTarget.value)

    let decrypted = await window.crypto.subtle.decrypt(
      {
        name: "AES-CBC",
        iv
      },
      key,
      ciphertext
    );

    let decoder = new TextDecoder();
    this.secretTarget.value = decoder.decode(decrypted)
    this.formTarget.requestSubmit()
  }

  importSecretKey(rawKey) {
    return window.crypto.subtle.importKey(
      "raw",
      rawKey,
      "AES-CBC",
      true,
      ["encrypt", "decrypt"]
    );
  }
}
