CollectionView = require "views/collection"
ComponentListView = require "views/component-list"

module.exports = class CollectionListView extends CollectionView
    tagName: "article"

    # Our constructor
    initialize: (opts) ->
        # The class to use for auto-creating child views
        @child = ComponentListView

        super opts

        @id = "job-list-#{@type}"
        @className = "#{@type}-list-collection"
        @next = opts.next if opts.next?
        @title = opts.title if opts.title?

        # Re-create the element name
        @setName()

        # Set template
        @template = require "templates/collection.list"

        # Return nothing
        null

    # Render the collection
    render: =>
        console.log "Rendering #{@type} list collection"
        @_rendered = true

        # Remove anything already there
        @$el.empty()

        # Rebuild the frame
        @$el.html @template
            type: @type
            next: @next
            title: @title
            cost: @collection.cost if @collection.cost?

        # Append all of the rendered children
        _(@_children).each (child) =>
            @$(".items").append child.render().$el

        # Return this
        @

