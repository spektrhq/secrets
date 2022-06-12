import { Controller } from "@hotwired/stimulus"
import { hex } from "../utils"

export default class extends Controller {
  static targets = [ "result", "form", "secret", "content", "iv", "link", "key" ]

  async create(e) {
    e.preventDefault();
    e.stopPropagation()
    let key = await window.crypto.subtle.generateKey(
      {
        name: "AES-CBC",
        length: 256
      },
      true,
      ["encrypt", "decrypt"]
    );

    let iv = window.crypto.getRandomValues(new Uint8Array(16));

    const key_buffer = await window.crypto.subtle.exportKey("raw", key)
    this.keyTarget.value = hex(key_buffer)

    let encoder = new TextEncoder();
    var content = encoder.encode(this.secretTarget.value);

    let ciphertext = await window.crypto.subtle.encrypt(
      {
        name:"AES-CBC",
        iv
      }, key, content
    )

    this.contentTarget.value = hex(ciphertext)
    this.ivTarget.value = hex(iv)
    this.formTarget.requestSubmit()
    this.resultTarget.classList.remove("hidden")
  }
}
