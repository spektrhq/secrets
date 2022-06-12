import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

import { Toggle } from "tailwindcss-stimulus-components"
application.register('toggle', Toggle)

export { application }
