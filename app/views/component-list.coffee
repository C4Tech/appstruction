ComponentView = require "views/component"
# _ = require "underscore"

module.exports = class ComponentListView extends ComponentView
  tagName: "li"

  initialize: (opts) ->
    @showAll = true
    @template = require "templates/component.list"
    @className = "#{@routeType} #{@routeType}-list
      #{@routeType}-list-item list-group-item"

    super opts

  render: ->
    @$el.html @template
      overviewItems: @model.overview()

    @
