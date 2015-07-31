system = require "system"

class ChoicesActions
  constructor: ->
    @generateActions "save"

  create: (name, text, id, singular, plural) ->
    @dispatch
      data: data
      navigateTo: navigateTo

module.exports = system.createActions ChoicesActions
