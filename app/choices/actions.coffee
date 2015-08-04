system = require "system"

class ChoicesActions
  constructor: ->
    @generateActions "save"

  create: (type, label, value) ->
    @dispatch
      value: value
      label: label
      type: type

module.exports = system.createActions ChoicesActions
