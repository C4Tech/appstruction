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
    localStorage.setItem @getStorageId(), JSON.stringify @data

    null

  readFromStorage: ->
    return unless window.localStorage?
    data = JSON.parse localStorage.getItem @getStorageId()

    data or {}

  createIndex: (job) ->
    "job-#{job.id}"

  findComponentIndex: (component, id) ->
    return 0 unless @current.components[component]?

    index = @current.components[component].items.findIndex (element) ->
      element.id is id
    index = @current.components[component].items.length unless index >= 0

    index

  addToCollection: (job) ->
    index = @createIndex job
    @count++ unless @data[index]?
    @data[index] = job

    null

  recalculate: (current) ->
    cost = 0.0
    cost += component.cost for key, component of current.components
    cost

  recalculateComponent: (component) ->
    cost = 0.0
    return cost unless component?.items?.length

    cost += item.cost for own key, item of component.items when item.cost > 0.0
    cost

  onSetCurrent: (payload) ->
    @setState
      current: payload

  onCreate: (payload) ->
    payload.components ?= {}

    @setState
      current: payload

  onUpdate: (payload) ->
    current = @current
    current[key] = value for own key, value of payload
    current.total = Cost.calculate current.subtotal, current.profitMargin

    @setState
      current: current

  onUpsertComponent: (payload) ->
    defaultComponent =
      cost: 0.0
      items: []

    current = @current
    component = current.components[payload.component] or defaultComponent
    index = @findComponentIndex payload.component, payload.data.id
    payload.data.id ?= index
    component.items[index] = payload.data

    component.cost = @recalculateComponent component
    current.components[payload.component] = component
    current.subtotal = @recalculate current
    current.total = Cost.calculate current.subtotal, current.profitMargin

    @setState
      current: current

  onSave: () ->
    @current.id ?= Date.now()
    @addToCollection @current
    @saveToStorage()
    @emitChange()
    null

module.exports = system.createStore JobStore
