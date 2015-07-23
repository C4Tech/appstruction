actions = require "navigation/actions"
system = require "system"

class NavigationStore
  constructor: ->
    @data =
      next: false
      nextParam: null
      prev: false
      prevParam: null
      title: null

    @bindActions actions

  updateData: (data) ->
    @setState
      data: data

  onSet: (payload) ->
    @updateData payload

  onSetNext: (payload) ->
    data = @data
    data.next = payload.link
    data.nextParam = payload.param
    @updateData data

  onSetPrev: (payload) ->
    data = @data
    data.prev = payload.link
    data.prevParam = payload.param
    @updateData data

  onSetTitle: (payload) ->
    data = @data
    data.title = payload.title
    @updateData data

module.exports = system.createStore NavigationStore
