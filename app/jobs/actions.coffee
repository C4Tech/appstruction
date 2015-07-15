system = require "system"

module.exports = class JobActions
  create: (data, navigateTo) ->
    @dispatch
      data: data
      navigateTo: navigateTo

  setCurrent: (job) ->
    @dispatch
      job: job

module.exports = system.createActions JobActions
