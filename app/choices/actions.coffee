system = require "system"

class ChoicesActions
  create: (name, text, id, singular, plural) ->
    @dispatch
      data: data
      navigateTo: navigateTo

module.exports = system.createActions ChoicesActions
