cordovaClass = class CordovaApp
  initialize: ->
    @bindEvents()
    true

  bindEvents: ->
    document.addEventListener "deviceready", @onDeviceReady, false
    true

  onDeviceReady: ->
    require "application"

app = new cordovaClass

app.initialize()
