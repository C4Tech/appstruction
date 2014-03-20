BaseView = require "views/base"

module.exports = class ComponentView extends BaseView
    # Our constructor
    initialize: (opts) ->
        # Set some basic options
        @type = opts.type if opts.type?
        @showAll = false unless @showAll?
        @templateFile = "templates/component.list"

        # Add attributes
        @className = @type

        # Re-create the element name
        @setName()

        # Return nothing
        null

    # Render the model
    render: ->
        # Set the HTML
        @$el.html @template
            row: @model.toJSON()
            cid: @model.cid
            cost: @model.calculate() if @model.calculate?
            types: if @model.types? then @model.types else null
            fields: @model.getFields(@showAll)

        # Return this
        @
