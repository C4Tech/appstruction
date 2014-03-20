CollectionView = require "views/collection"
ComponentListView = require "views/component-list"

module.exports = class CollectionListView extends CollectionView
    # Our constructor
    initialize: (opts) ->
        # The class to use for auto-creating child views
        @child = ComponentListView

        super opts

        @id = "job-list-#{@modelType}" unless @id
        @className = "#{@modelType}-list-collection" unless @className
        @next = opts.next if opts.next?
        @title = opts.title if opts.title?
        @step = opts.step if opts.step?

        # Re-create the element name
        @setName()

        # Set template
        @template = require "templates/collection.list"

        # Return nothing
        null

    # Render the collection
    render: =>
        console.log "Rendering #{@modelType} list collection"
        @_rendered = true

        # Remove anything already there
        @$el.empty()

        # Rebuild the frame
        @$el.html @template
            modelType: @modelType
            title: @title
            cost: @collection.calculate() if @collection.calculate?

        # Append all of the rendered children
        _(@_children).each (child) =>
            @$(".items").append child.render().$el

        # Return this
        @

