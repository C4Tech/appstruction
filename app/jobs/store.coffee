actions = require "jobs/actions"
system = require "system"

class JobStore
  constructor: ->
    @count = 0
    @current = {}
    @data = {}

    @bindActions actions

  createIndex: (job) ->
    "job-#{job.id}"

  findComponentIndex: (component, id) ->
    index = @current.components[component].items.findIndex (element) ->
      element.id is id

    index = @current.components[component].items.length unless index > 0
    index

  addToCollection: (job) ->
    index = @createIndex job
    @count++ unless @data[index]?
    @data[index] = job
    null

  navigate: (to) ->
    App.transitionTo to if to?

  recalculate: ->
    cost = 0.0
    cost += component.cost for own key, component of @current.components
    cost

  recalculateComponent: (component) ->
    cost = 0.0
    return cost unless component?.items

    cost += item.cost for own key, item of component.items
    cost

  onCreate: (payload) ->
    @current = payload.data
    @current.components ?= {}
    @navigate payload.navigateTo
    null

  onUpdate: (payload) ->
    @current[key] = value for own key, value of payload.data
    @navigate payload.navigateTo
    null

  onUpdateComponent: (payload) ->
    component = @current.components[payload.component] ?=
      cost: 0.0
      items: []

    index = @findComponentIndex payload.component, payload.data.id
    payload.data.id ?= index
    component.items[index] = payload.data
    component.cost = @recalculateComponent component

    @current.components[payload.component] = component
    @current.subtotal = @recalculate()

    profitMargin = @current.profitMargin ? 0
    profitMargin /= 100

    @current.total = @current.subtotal
    @current.total += @current.subtotal * profitMargin

    @navigate payload.navigateTo if payload.navigateTo?
    null

  onSave: (payload) ->
    @addToCollection @current
    @saveToStorage()
    @navigate payload.navigateTo
    null

module.exports = system.createStore JobStore
