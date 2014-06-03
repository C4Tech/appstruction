CollectionView = require "views/collection"
ComponentFormView = require "views/component-form"

module.exports = class CollectionFormView extends CollectionView
    tagName: "article"

    # Our constructor
    initialize: (opts) ->
        # The class to use for auto-creating child views
        @child = ComponentFormView

        super opts

        @routeType = opts.routeType if opts.routeType?
        @id = "job-form-#{@routeType}"
        @className = "#{@routeType}-form-collection col-xs-12"
        @multiple = switch @routeType
            when "create", "job", "concrete" then false
            else true
        @step = opts.step if opts.step?
        @title = opts.title if opts.title?

        # Re-create the element name
        @setName()

        # Set template
        @template = require "templates/collection.form"

        # Return nothing
        null

    # Render the collection
    render: =>
        console.log "Rendering #{@routeType} collection"
        @_rendered = true

        # Remove anything already there
        @$el.empty()

        # Rebuild the frame
        @$el.html @template
            routeType: @routeType
            step: @step
            title: @title
            multiple: @multiple

        # Append all of the rendered children
        _(@_children).each (child) =>
            @$(".items").append child.render().$el
            @$('#component-help').text child.model.help

        # Apply select2 widget
        @$('select').select2
            allowClear: true
            minimumResultsForSearch: 6

        # Return this
        @
