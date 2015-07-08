BaseView = require "views/base"
CollectionListView = require "views/collection-list"
Choices = require "models/choices"
# _ = require "underscore"
#
module.exports = class JobView extends BaseView
  initialize: (opts) ->
    @_children = []
    @routeType = opts.routeType if opts.routeType?
    @id = @model.cid
    @className = "#{@routeType}-overview"
    @template = require "templates/job"
    @setName()
    @addCollection collection for collection in Choices.get "jobRoutes"

    null

  addCollection: (collection) ->
    data = if @model.attributes[collection] ? false
    @_children.push new CollectionListView
      className: "job-list-collection"
      collection: data
      title: collection
      modelType: collection
      routeType: @routeType

    null

  render: ->
    console.log "Rendering job overview"
    @model.calculate()

    @$el.html @template
      row: @model.getFields()
      cost: @model.cost.toFixed 2

    _(@_children).each (child) =>
      @$(".job.items").append child.render().$el

    @
