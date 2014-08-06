BaseView = require "views/base"
CollectionListView = require "views/collection-list"
ChoicesSingleton = require "models/choices"

module.exports = class JobView extends BaseView
    # Our constructor
    initialize: (opts) ->
        # Our children views
        @_children = []

        # Set some variables
        @routeType = opts.routeType if opts.routeType?
        @id = @model.cid
        @className = "#{@routeType}-overview"

        # Re-create the element name
        @setName()

        # Set template
        @template = require "templates/job"

        # Instantiate views for each collection in model
        for collection in ChoicesSingleton.get('job_routes')
            data = if @model.attributes[collection]? then @model.attributes[collection] else false

            @_children.push new CollectionListView
                className: "job-list-collection"
                collection: data
                title: collection
                modelType: collection
                routeType: @routeType

        # Return nothing
        null

    # Render the collection
    render: ->
        console.log "Rendering job overview"
        @model.calculate()

        # Reset the contents
        @$el.html @template
            row: @model.getFields()
            cost: @model.cost.toFixed(2)

        # Append all of the rendered children
        _(@_children).each (child) =>
            @$(".job.items").append child.render().$el

        # Return this
        @