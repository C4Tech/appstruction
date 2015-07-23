actions = require "jobs/actions"
system = require "system"

class JobStore
  constructor: ->
    @count = 0
    @current = {}
    @data = {}

    @bindActions actions

  readFromStorage: ->
    null

  saveToStorage: ->
    null

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
    @emitChange()

  recalculate: (current) ->
    cost = 0.0
    cost += component.cost for own key, component of current.components
    cost

  recalculateComponent: (component) ->
    cost = 0.0
    return cost unless component?.items

    cost += item.cost for own key, item of component.items
    cost

  onCreate: (payload) ->
    current = payload.data
    current.components ?= {}
    @setState
      current: current

  onUpdate: (payload) ->
    current = @current
    current[key] = value for own key, value of payload.data
    @setState
      current: current

  onUpdateComponent: (payload) ->
    current = @current
    component = @current.components[payload.component] ?=
      cost: 0.0
      items: []

    index = @findComponentIndex payload.component, payload.data.id
    payload.data.id ?= index
    component.items[index] = payload.data
    component.cost = @recalculateComponent component

    current.components[payload.component] = component
    current.subtotal = @recalculate()

    profitMargin = current.profitMargin ? 0
    profitMargin /= 100

    current.total = current.subtotal
    current.total += current.subtotal * profitMargin
    @setState
      current: current

  onSave: (payload) ->
    @addToCollection @current
    @saveToStorage()
    null

module.exports = system.createStore JobStore
