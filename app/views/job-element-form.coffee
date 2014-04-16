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
        @className = "#{@routeType} #{@routeType}-form col-xs-12 form-horizontal"
        @step = opts.step if opts.step?
        @title = opts.title if opts.title?
        @jobRoutes = opts.jobRoutes if opts.jobRoutes?

        # Set template
        @templateFile = "templates/#{@routeType}.form"
        @template = require @templateFile

        if @routeType == 'save'
            # Our children views
            @_children = []

            # Instantiate views for each collection in model
            for collection in @jobRoutes
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
            cost: @model.cost
            fields: @model.getFields(@showAll)

        # Apply select2 widget for fields accepting user-created options
        field_options = null
        for field in @model.fields
            if field.fieldType == 'hidden' and field.show and field.options?
                field_options = field.options
                @$('input[name=' + field.name + ']').select2
                    width: 'resolve'
                    data: field_options
                    createSearchChoice: (term) ->
                        id: String(field_options.length + 1)
                        text: term

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

            option_found = _.some(choices_options, (item) ->
                item.id == selected_option.id and item.text == selected_option.text
            )

            if not option_found
                select2_selected_option = target.select2 'data'
                choices_options.push
                    id: select2_selected_option.id
                    text: select2_selected_option.text

        console.log "View changed", target.attr('name'), target.val()

        # Return nothing
        null
