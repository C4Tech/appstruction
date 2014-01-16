BaseView = require "views/base"

module.exports = class ComponentView extends BaseView
    # Our constructor
    initialize: (opts) ->
        # Set some basic options
        @self = @constructor
        @type = opts.type if opts.type?

        # Set template
        @templateFile = "templates/#{@type}"
        @template = require @templateFile

        # Add attributes
        @className = @type

        # Return nothing
        null

    # Render the model
    render: =>
        # Set the HTML
        @$el.html @template
            row: @model.toJSON()
            cid: @model.cid

        # Return this
        @
