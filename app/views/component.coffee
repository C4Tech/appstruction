BaseView = require "views/base"

module.exports = class ComponentView extends BaseView
    # Our constructor
    initialize: (opts) ->
        # Set some basic options
        @routeType = opts.routeType if opts.routeType?
        @showAll = false unless @showAll?
        @templateFile = "templates/component.list"

        # Add attributes
        @className = @routeType

        # Re-create the element name
        @setName()

        # Return nothing
        null

    addSelectOption: (field) ->
        @$('input[name=' + field.name + ']').select2
            width: 'resolve'
            data: field.options
            createSearchChoice: (term) ->
                id: String(field.options.length + 1)
                text: term

    # Render the model
    render: ->
        # Set the HTML
        @$el.html @template
            row: @model.toJSON()
            cid: @model.cid
            cost: @model.calculate() if @model.calculate?
            fields: @model.getFields(@showAll)

        # Apply select2 widget for fields accepting user-created options
        for field in @model.fields
            @addSelectOption field if field.fieldType == 'hidden' and field.show and field.options?

        # Return this
        @
