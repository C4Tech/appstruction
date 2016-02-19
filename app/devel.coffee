class WebApp
  initialize: ->
    @bindEvents()
    true

  bindEvents: ->
    document.addEventListener "DOMContentLoaded", @onDeviceReady, false
    true

  onDeviceReady: ->
    log.setLevel "debug"
    require "initialize"

  share: (subject, message, file) ->
    console.log "Sharing '#{subject}': #{message}"

  email: (to, subject, message, file) ->
    console.log "Emailing '#{subject}': #{message}"
    window.plugins.socialsharing.shareViaEmail message,
      subject,
      to,
      null,
      null,
      file

window.app = new WebApp

window.app.initialize()
