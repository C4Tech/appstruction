BaseView = require "views/base"
ComponentView = require "views/component"

module.exports = class CollectionView extends BaseView
    # Our constructor
    initialize: (opts) ->
        # Set some variables
        @routeType = opts.routeType if opts.routeType?
        @modelType = if opts.modelType? then opts.modelType else "collection"
        @className = "#{@modelType}-collection" unless @className?

        @child = opts.child if opts.child?
        @child = ComponentView if not @child?

        # Our children views
        @_children = []

        # Have we rendered yet?
        @_rendered = false

        # Re-create the element name
        @setName()

        # Instantiate views for each model already in collection
        @collection.each @add

        # Bind the auto-creation of child views to the collection add method
        _(@).bindAll 'add', 'remove'
        @listenTo @collection, 'add', @add
        @listenTo @collection, 'remove', @remove

        # Return nothing
        null

    # Render the collection
    render: ->
        console.log "Rendering #{@modelType} collection"
        @_rendered = true

        # Remove anything already there
        @$el.empty()

        # Append all of the rendered children
        _(@_children).each (child) =>
            @$(".items").append child.render().$el

        # Return this
        @

    # Event callback to add a view when a model is added to the collection
    add: (model) =>
        model.index = @_children.length
        child = new @child
            model: model
            modelType: @modelType
            routeType: @routeType

        # Add child to stack
        @_children.push child

        # Append rendered child for output
        @$(".items").append child.render().$el if @_rendered

        # Return nothing
        null

    # Event callback to remove a view when a model is removed from the collection
    remove: (model) ->
        # Find the view to remove by model
        orphan = _(@_children).select (child) ->
            child.model is model
        orphan = orphan.unshift()

        # Stop child from listening to events
        orphan.stopListening()

        # Remove child from own collection
        @_children = _(@_children).without orphan

        # Remove child from browser
        orphan.$el.remove() if @_rendered

        # Return nothing
        null
