ComponentView = require "views/component"

module.exports = class ComponentListView extends ComponentView
  tagName: "li"

  initialize: (opts) ->
    @showAll = true

    super opts

    # Set template
    @template = require "templates/component.list"

    # Add attributes
    @className = "#{@routeType} #{@routeType}-list #{@routeType}-list-item list-group-item"

    # Re-create the element name
    @setName()

    # Return nothing
    null

  render: ->
    # Set the HTML
    @$el.html @template
      overview_items: @model.overview()

    # Return this
    @
