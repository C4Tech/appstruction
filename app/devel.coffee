Application = require "application"

$ ->
  log.setLevel "debug", false
  Router = new Application clickType: "click"
  Backbone.history.start()
