ComponentView = require "views/component"
ChoicesSingleton = require "models/choices"

module.exports = class ComponentFormView extends ComponentView
    events:
        "change .field": "refresh"

    initialize: (opts) ->
        super opts

        # Set template
        @template = require "templates/component.form"

        # Add attributes
        @className = "#{@routeType} #{@routeType}-form #{@routeType}-form-item"

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
        name = target.attr('name')
        @model.set name, target.val()
        field = @model.getField name

        if field? and field.optionsType? and field.fieldType == 'hidden'
            selected_option = target.select2('data')
            choices_options = ChoicesSingleton.get field.optionsType

            option_found = _.some choices_options, (item) ->
                item.id == selected_option.id and item.text == selected_option.text

            if not option_found
                select2_selected_option = target.select2 'data'
                choices_options.push
                    id: select2_selected_option.id
                    text: select2_selected_option.text

        console.log "View changed", target.attr('name'), target.val()
        $(".#{@routeType}.cost").text @model.collection.calculate()

        null
