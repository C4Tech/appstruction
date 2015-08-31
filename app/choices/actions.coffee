system = require "system"

class ChoicesActions
  constructor: ->
    @generateActions "save"

  create: (type, label, value) ->
    @dispatch
      value: value
      label: label
      type: type

  delete: (type, item) ->
    @dispatch
      type: type
      item: item

module.exports = system.createActions ChoicesActions
