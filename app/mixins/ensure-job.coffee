JobStore = require "jobs/store"

module.exports =
  componentWillMount: ->
    @goHome() unless JobStore.getState().current.components?

  goHome: ->
    @transitionTo "add"
