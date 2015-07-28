system = require "system"

module.exports = class JobActions
  create: (data, navigateTo) ->
    @dispatch
      data: data
      navigateTo: navigateTo

  setCurrent: (job) ->
    @dispatch
      job: job

  createComponent: (component, object = {}) ->
    @dispatch
      component: component
      data: object

  updateComponent: (component, object = {}) ->
    @dispatch
      component: component
      data: object

module.exports = system.createActions JobActions
