CollectionView = require "views/collection"
ComponentFormView = require "views/component-form"

module.exports = class CollectionFormView extends CollectionView
    tagName: "article"

    # Our constructor
    initialize: (opts) ->
        # The class to use for auto-creating child views
        @child = ComponentFormView

        super opts

        @id = "job-form-#{@type}"
        @className = "#{@type}-form-collection col-xs-12"
        @multiple = switch @type
            when "type", "job", "concrete" then false
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
        console.log "Rendering #{@type} collection"
        @_rendered = true

        # Remove anything already there
        @$el.empty()

        # Rebuild the frame
        @$el.html @template
            type: @type
            step: @step
            title: @title
            multiple: @multiple

        # Append all of the rendered children
        _(@_children).each (child) =>
            @$(".items").append child.render().$el
            @$('#component-help').text child.model.help

        if @type is 'concrete'
            @$('input[data-mask=percentage]').mask '##0.00%', {reverse: true}

        @$('select').select2
            allowClear: true
            minimumResultsForSearch: 6

        # Return this
        @
