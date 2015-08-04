class CordovaApp
  initialize: ->
    @bindEvents()
    true

  bindEvents: ->
    document.addEventListener "deviceready", @onDeviceReady, false
    true

  onDeviceReady: ->
    log.setLevel "warn"
    require "initialize"

  share: (subject, message, file) ->
    window.plugins.socialsharing.share message,
      subject,
      file

  email: (to, subject, message, file) ->
    window.plugins.socialsharing.shareViaEmail message,
      subject,
      to,
      null,
      null,
      file

window.app = new CordovaApp

window.app.initialize()
