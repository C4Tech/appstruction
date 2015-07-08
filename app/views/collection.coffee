BaseView = require "views/base"
ComponentView = require "views/component"
# _ = require "underscore"

module.exports = class CollectionView extends BaseView
  initialize: (opts) ->
    @modelType = opts.modelType ? "collection"
    @className ?= "#{@modelType}-collection"

    @child = opts.child if opts.child?
    @child ?= ComponentView
    @_children = []
    @_rendered = false

    @setName()

    @collection.each @add
    _(@).bindAll "add", "remove"
    @listenTo @collection, "add", @add
    @listenTo @collection, "remove", @remove

    null

  render: ->
    console.log "Rendering #{@modelType} collection"
    @_rendered = true

    @$el.empty()

    _(@_children).each (child) =>
      @$(".items").append child.render().$el

    @

  add: (model) =>
    model.index = @_children.length
    child = new @child
      model: model
      modelType: @modelType
      routeType: @routeType

    @_children.push child
    @$(".items").append child.render().$el if @_rendered

    null

  remove: (model) ->
    orphan = _(@_children).select (child) ->
      child.model is model
    orphan = orphan.unshift()

    orphan.stopListening()
    @_children = _(@_children).without orphan
    orphan.$el.remove() if @_rendered

    null
