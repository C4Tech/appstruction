BaseView = require "views/base"

module.exports = class ComponentView extends BaseView
    # Our constructor
    initialize: (opts) ->
        # Set some basic options
        @type = opts.type if opts.type?
        @templateFile = "templates/component.list"

        # Add attributes
        @className = @type

        # Re-create the element name
        @setName()

        # Return nothing
        null

    # Render the model
    render: ->
        @model.calculate() if @model.calculate?

        # Set the HTML
        @$el.html @template
            row: @model.toJSON()
            cid: @model.cid
            cost: @model.cost if @model.cost?
            types: if @model.types? then @model.types else null
            fields: @model.getFields()

        # Return this
        @
