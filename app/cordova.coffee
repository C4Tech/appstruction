Application = require "application"

class Cordova
  initialize: ->
    @bindEvents()
    true

  bindEvents: ->
    document.addEventListener "deviceready", @onDeviceReady, false
    true

  onDeviceReady: =>
    @router = new Application
    Backbone.history.start()
    @receivedEvent "deviceready"

  receivedEvent: (id) ->
    parentElement = document.getElementById id
    listeningElement = parentElement.querySelector ".listening"
    receivedElement = parentElement.querySelector ".received"

    listeningElement.setAttribute "style", "display:none;"
    receivedElement.setAttribute "style", "display:block;"

    console.log "Received Event: #{id}"
    true

module.exports = new Cordova
