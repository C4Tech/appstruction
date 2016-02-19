actions = require "navigation/actions"
system = require "system"

class NavigationStore
  constructor: ->
    @data = @getDefaultData()

    @bindActions actions

  getDefaultData: ->
    {
      next: false
      nextParam: null
      prev: false
      prevParam: null
      title: null
    }

  updateData: (data) ->
    @setState
      data: data

  onSet: (payload) ->
    @updateData payload

  onUnset: ->
    @updateData @getDefaultData()

  onSetNext: (payload) ->
    data = @data
    data.next = payload.link
    data.nextParam = payload.param
    @updateData data

  onUnsetNext: ->
    data = @data
    data.next = @getDefaultData().next
    data.nextParam = @getDefaultData().nextParam
    @updateData data

  onSetPrev: (payload) ->
    data = @data
    data.prev = payload.link
    data.prevParam = payload.param
    @updateData data

  onUnsetPrev: ->
    data = @data
    data.prev = @getDefaultData().prev
    data.prevParam = @getDefaultData().prevParam
    @updateData data

  onSetTitle: (payload) ->
    data = @data
    data.title = payload
    @updateData data

  onUnsetTitle: ->
    data = @data
    data.title = @getDefaultData().title
    @updateData data

module.exports = system.createStore NavigationStore
