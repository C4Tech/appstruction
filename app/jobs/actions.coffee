system = require "system"

module.exports = class JobActions
  constructor: ->
    @generateActions "create", "update", "setCurrent", "save"

  createComponent: (component, object = {}) ->
    @dispatch
      component: component
      data: object

  updateComponent: (component, object = {}) ->
    @dispatch
      component: component
      data: object

module.exports = system.createActions JobActions
