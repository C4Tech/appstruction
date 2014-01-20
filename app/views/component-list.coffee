ComponentView = require "views/component"

module.exports = class ComponentListView extends ComponentView
    tagName: "li"

    initialize: (opts) ->
        @showAll = true

        super opts

        # Set template
        @template = require "templates/component.list"

        # Add attributes
        @className = "#{@type} #{@type}-list #{@type}-list-item list-group-item"

        # Re-create the element name
        @setName()

        # Return nothing
        null
