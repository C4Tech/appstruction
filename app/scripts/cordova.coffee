app = {}

# Application Constructor
app.initialize = ->
    this.bindEvents()
    true

# Bind Event Listeners
#
# Bind any events that are required on startup. Common events are:
# 'load', 'deviceready', 'offline', and 'online'.
app.bindEvents = ->
    document.addEventListener 'deviceready', this.onDeviceReady, false
    true

# deviceready Event Handler
#
# The scope of 'this' is the event. In order to call the 'receivedEvent'
# function, we must explicity call 'app.receivedEvent(...);'
app.onDeviceReady = ->
    app.receivedEvent 'deviceready'

# Update DOM on a Received Event
app.receivedEvent = (id) ->
    parentElement = document.getElementById id
    listeningElement = parentElement.querySelector '.listening'
    receivedElement = parentElement.querySelector '.received'

    listeningElement.setAttribute 'style', 'display:none;'
    receivedElement.setAttribute 'style', 'display:block;'

    console.log 'Received Event: ' + id
    true
