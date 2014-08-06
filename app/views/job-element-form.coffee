ComponentView = require "views/component"
CollectionListView = require "views/collection-list"
ChoicesSingleton = require "models/choices"

module.exports = class JobElementFormView extends ComponentView
    tagName: "article"

    events:
        "change .field": "refresh"

    initialize: (opts) ->
        super opts

        # Add attributes
        @routeType = opts.routeType if opts.routeType?
        @id = "job-form-#{@routeType}"
        @className = "container #{@routeType} #{@routeType}-form"
        @step = opts.step if opts.step?
        @title = opts.title if opts.title?

        # Set template
        @templateFile = "templates/#{@routeType}.form"
        @template = require @templateFile

        if @routeType == 'save'
            # Our children views
            @_children = []

            # Instantiate views for each collection in model
            for collection in ChoicesSingleton.get('job_routes')
                data = if @model.attributes[collection]? then @model.attributes[collection] else false
                @_children.push new CollectionListView
                    className: "job-list-collection"
                    collection: data
                    title: collection
                    modelType: collection
                    routeType: @routeType

        # Re-create the element name
        @setName()

        # Bind the auto-update of the model when the view is altered
        _.bindAll @, "refresh"

        # Return nothing
        null

    addSelectOption: (field) ->
        @$('input[name=' + field.name + ']').select2
            width: 'resolve'
            data: field.options
            createSearchChoice: (term) ->
                option_found = _.some field.options, (item) ->
                    item.text == term
                if option_found
                    return null
                else
                    id: String(field.options.length + 1)
                    text: term

    # Render the collection
    render: =>
        console.log "Rendering #{@routeType} element"

        # Remove anything already there
        @$el.empty()

        # Rebuild the frame
        @$el.html @template
            row: @model.toJSON()
            cid: @model.cid
            routeType: @routeType
            step: @step
            title: @title
            cost: @model.cost.toFixed(2)
            fields: @model.getFields(@showAll)

        # Apply select2 widget for fields accepting user-created options
        for field in @model.fields
            @addSelectOption field if field.fieldType == 'hidden' and field.show and field.options?

        # Apply profit margin to subtotal as it is typed in
        self = @
        @$('#job-profit-margin').keyup ->
            profit_margin = self.$(@).val()
            $subtotal = self.$('#job-subtotal')
            subtotal_original = $subtotal.data('original')

            # check if profit_margin is a valid number
            if isNaN(parseFloat(profit_margin)) or !isFinite(profit_margin)
                $subtotal.val(subtotal_original)
                return

            profit_margin /= 100
            subtotal_original = parseFloat(subtotal_original)
            subtotal_value = subtotal_original + (subtotal_original * profit_margin)
            $subtotal.val(subtotal_value.toFixed(2))

        # Append all of the rendered children
        _(@_children).each (child) =>
            @$(".job.items").append child.render().$el

        # Return this
        @

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

        # Return nothing
        null