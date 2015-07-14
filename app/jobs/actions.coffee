system = require "system"

module.exports = class JobActions
  create: (data, navigateTo) ->
    @dispatch
      data: data
      navigateTo: navigateTo

module.exports = system.createActions JobActions
