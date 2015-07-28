actions = require "jobs/actions"
config = require "config"
Cost = require "util/cost"
system = require "system"

class JobStore
  constructor: ->
    @data = @readFromStorage()
    @count = Object.keys(@data).length or 0
    @current = {}

    @bindActions actions

  getStorageId: ->
    prefix = config.storagePrefix
    "#{prefix}-jobs"

  saveToStorage: ->
    return unless window.localStorage?
    localStorage.setItem @getStorageId(), JSON.stringify @options

    null

  readFromStorage: ->
    return unless window.localStorage?
    data = JSON.parse localStorage.getItem @getStorageId()

    data or {}

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
    defaultComponent =
      cost: 0.0
      items: []

    current = @current
    component = current.components[payload.component] or defaultComponent

    # Update/Insert component item
    index = @findComponentIndex payload.component, payload.data.id
    payload.data.id ?= index
    component.items[index] = payload.data
    component.cost = @recalculateComponent component
    current.components[payload.component] = component

    # Recalculate job
    current.subtotal = @recalculate current
    current.total = Cost.calculate current.subtotal, current.profitMargin

    @setState
      current: current

  onSave: (payload) ->
    @addToCollection @current
    @saveToStorage()
    @emitChange()
    null

module.exports = system.createStore JobStore
