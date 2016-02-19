system = require "system"

module.exports = class JobActions
  constructor: ->
    @generateActions "create",
      "update",
      "delete",
      "setCurrent",
      "save",
      "deleteGroup"

  upsertComponent: (component, object = {}) ->
    @dispatch
      component: component
      data: object

module.exports = system.createActions JobActions
