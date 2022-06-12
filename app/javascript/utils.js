export function hex(arrayBuffer) {
    return Array.prototype.map.call(
      new Uint8Array(arrayBuffer),
      n => n.toString(16).padStart(2, "0")
  ).join("");
}

export function hex2ArrayBuffer(hex) {
  return new Uint8Array(hex.match(/../g).map(h=>parseInt(h,16))).buffer
}
