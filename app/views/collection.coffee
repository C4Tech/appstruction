BaseView = require "views/base"
ComponentView = require "views/component"
# _ = require "underscore"

module.exports = class CollectionView extends BaseView
  initialize: (opts) ->
    @modelType = opts.modelType ? "collection"
    @className ?= "#{@modelType}-collection"

    @child = opts.child if opts.child?
    @child ?= ComponentView
    @children = []
    @rendered = false

    @setName()

    @collection.each @add
    _(@).bindAll "add", "remove"
    @listenTo @collection, "add", @add
    @listenTo @collection, "remove", @remove

    null

  render: ->
    console.log "Rendering #{@modelType} collection"
    @rendered = true

    @$el.empty()

    _(@children).each (child) =>
      @$(".items").append child.render().$el

    @

  add: (model) =>
    model.index = @children.length
    child = new @child
      model: model
      modelType: @modelType
      routeType: @routeType

    @children.push child
    @$(".items").append child.render().$el if @rendered

    null

  remove: (model) ->
    orphan = _(@children).select (child) ->
      child.model is model
    orphan = orphan.unshift()

    orphan.stopListening()
    @children = _(@children).without orphan
    orphan.$el.remove() if @rendered

    null
