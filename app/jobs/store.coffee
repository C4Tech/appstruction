system = require "system"
actions = require "jobs/actions"

class JobStore
  constructor: ->
    @count = 0
    @current = {}
    @data = {}

    @bindActions actions

  createIndex: (job) ->
    "job-#{job.id}"

  addToCollection: (job) ->
    index = @createIndex job
    @count++ unless @data[index]?
    @data[index] = job
    null

  navigate: (to) ->
    App.transitionTo to if to?

  onCreate: (payload) ->
    @current = payload.data
    @navigate payload.navigateTo
    null

  onSetComponent: (payload) ->
    @current[payload.component] = payload.data
    @navigate payload.navigateTo
    null

  onUpdate: (payload) ->
    @current[key] = value for own key, value of payload.data
    @navigate payload.navigateTo
    null

  onSave: (payload) ->
    @addToCollection @current
    @saveToStorage()
    @navigate payload.navigateTo
    null

module.exports = system.createStore JobStore
