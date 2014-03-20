BaseView = require "views/base"
CollectionListView = require "views/collection-list"

module.exports = class JobView extends BaseView
    # Our constructor
    initialize: (opts) ->
        # Our children views
        @_children = []

        # Set some variables
        @id = @model.cid
        @className = "#{@type}-overview"

        # Re-create the element name
        @setName()

        # Set template
        @template = require "templates/job"

        # Instantiate views for each collection in model
        collections = ["concrete", "labor", "materials", "equipment"]
        for collection in collections
            data = if @model.attributes[collection]? then @model.attributes[collection] else false
            @_children.push new CollectionListView
                className: "job-list-collection"
                collection: data
                title: collection
                type: collection

        # Return nothing
        null

    # Render the collection
    render: ->
        console.log "Rendering job overview"
        @model.calculate()

        # Reset the contents
        @$el.html @template
            row: @model.getFields()
            cost: @model.cost

        # Append all of the rendered children
        _(@_children).each (child) =>
            @$(".job.items").append child.render().$el

        # Return this
        @
