ComponentView = require "views/component"
CollectionListView = require "views/collection-list"

module.exports = class JobElementFormView extends ComponentView
    tagName: "article"

    events:
        "change .field": "refresh"

    initialize: (opts) ->
        super opts

        # Set template
        @routeType = opts.routeType if opts.routeType?
        @templateFile = "templates/#{@routeType}.form"
        @template = require @templateFile

        # Add attributes
        @id = "job-form-#{@routeType}"
        @className = "#{@routeType} #{@routeType}-form col-xs-12 form-horizontal"
        @step = opts.step if opts.step?
        @title = opts.title if opts.title?
        @jobRoutes = opts.jobRoutes if opts.jobRoutes?

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
            types: @model.types

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
        @model.set target.attr('name'), target.val()

        console.log "View changed", target.attr('name'), target.val()

        # Return nothing
        null
