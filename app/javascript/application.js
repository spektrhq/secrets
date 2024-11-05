// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "controllers"

import ClipboardJS from "clipboard-js"

document.addEventListener('turbo:load', function(){
  new ClipboardJS('.clipboard');
}, false);
