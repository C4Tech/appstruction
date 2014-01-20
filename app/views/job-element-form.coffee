ComponentView = require "views/component"

module.exports = class JobElementFormView extends ComponentView
    tagName: "article"

    events:
        "change .field": "refresh"

    initialize: (opts) ->
        super opts

        # Set template
        @templateFile = "templates/#{@type}.form"
        @template = require @templateFile

        # Add attributes
        @id = "job-form-#{@type}"
        @className = "#{@type} #{@type}-form col-xs-12 form-horizontal"
        @next = opts.next if opts.next?
        @title = opts.title if opts.title?

        # Re-create the element name
        @setName()

        # Bind the auto-update of the model when the view is altered
        _.bindAll @, "refresh"

        # Return nothing
        null

    # Render the collection
    render: =>
        console.log "Rendering #{@type} element"

        # Remove anything already there
        @$el.empty()

        # Rebuild the frame
        @$el.html @template
            row: @model.toJSON()
            cid: @model.cid
            type: @type
            next: @next
            title: @title
            cost: @model.cost
            types: @model.types

        # Append all of the rendered children
        _(@_children).each (child) =>
            @$el.append child.render().$el

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
