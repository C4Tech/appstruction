ComponentView = require "views/component"

module.exports = class CollectionView extends Backbone.View
    # The model/collection type to use
    type: "collection"

    # The class to use for auto-creating child views
    child: ComponentView

    # Our children views
    _children: []

    # Have we rendered yet?
    _rendered = false

    # Our constructor
    initialize: (opts) ->
        # Set some variables
        @type = opts.type if opts.type?
        @className = "#{@type}-collection"
        @child = opts.child if opts.child?

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
        console.log "Rendering #{@type} collection"
        @_rendered = true

        # Remove anything already there
        @$el.empty()

        # Append all of the rendered children
        _(@_children).each (child) =>
            @$el.append child.render().$el

        # Activate jQuery mobile stuff
        @$el.enhanceWithin()

        # Return this
        @
        
    # Event callback to add a view when a model is added to the collection
    add: (model) =>
        child = new @child
            model: model
            type: @type

        # Add child to stack
        @_children.push child

        # Append rendered child for output
        @$el.append child.render().$el if @_rendered

        # Activate jQuery mobile stuff
        @$el.enhanceWithin()

        # Return nothing
        null

    # Event callback to remove a view when a model is removed from the collection
    remove: (model) =>
        # Find the view to remove by model
        orphan = _(@_children).select (child) ->
            child.model is model
        orphan = orpan.unshift()

        # Remove child from own collection
        @_children = _(@_children).without orphan

        # Remove child from browser
        @$(orphan.el).remove() if @_rendered

        # Return nothing
        null
