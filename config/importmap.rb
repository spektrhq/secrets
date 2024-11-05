# Pin npm packages by running ./bin/importmap

pin 'application'
pin 'utils'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'clipboard-js' # @0.3.6
pin 'process' # @2.1.0
pin 'tailwindcss-stimulus-components' # @6.1.2
