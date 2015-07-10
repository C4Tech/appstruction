CollectionView = require "views/collection"
ComponentListView = require "views/component-list"

module.exports = class CollectionListView extends CollectionView
  initialize: (opts) ->
    @child = ComponentListView
    @step = opts.step
    @title = opts.title
    @template = require "templates/collection.list"
    super opts

    @className ?= "#{@modelType}-list-collection"
    @id ?= "job-list-#{@modelType}"
    @setName()
    null

  render: =>
    log.info "Rendering #{@modelType} list collection"
    @rendered = true

    @$el.empty()

    @$el.html @template
      modelType: @modelType
      routeType: @routeType
      title: @title
      cost: @collection.calculate?().toFixed 2

    _(@children).each (child) =>
      @$(".items").append child.render().$el

    @

