CollectionView = require "views/collection"

module.exports = class CollectionFormView extends CollectionView
    # The class to use for auto-creating child views
    child: ComponentFormView

    templateFile = "templates/collection.form"

    next: null
    title: ""
    multiple: true

    # Our constructor
    initialize: (opts) ->
        super opts

        @next = opts.next if opts.next?
        @title = opts.title if opts.title?
        @className = "#{@type}-form-collection"
        @multiple = false if @type is "type" or @type is "job" or @type is "concrete"

        # Set template
        @template = require @templateFile

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
            next: @next
            title: @title
            multiple: @multiple

        # Append all of the rendered children
        _(@_children).each (child) =>
            @$el.append child.render().$el

        # Activate jQuery mobile stuff
        @$el.enhanceWithin()

        # Return this
        @

