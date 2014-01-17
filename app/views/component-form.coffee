ComponentView = require "views/component"

module.exports = class ComponentFormView extends ComponentView
    events:
        "change .field": "refresh"

    initialize: (opts) ->
        super opts

        # Set template
        @template = require "templates/component.form"

        # Add attributes
        @className = "#{@type} #{@type}-form #{@type}-form-item"

        # Re-create the element name
        @setName()

        # Bind the auto-update of the model when the view is altered
        _.bindAll @, "refresh"

        # Return nothing
        null

    # Event callback to update the model on input change
    refresh: (event) =>
        # Get the current element being modified
        target = $ event.currentTarget

        # Update the model
        @model.set target.attr('name'), target.val()

        console.log "View changed", target.attr('name'), target.val()
        $(".#{@type}.cost").text @model.collection.calculate()

        null
