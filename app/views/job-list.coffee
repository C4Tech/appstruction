ComponentView = require "views/component"

module.exports = class JobListView extends ComponentView
    initialize: (opts) ->
        super opts

        # Set template
        @template = require "templates/job.list"

        # Add attributes
        @className = "#{@type} #{@type}-list #{@type}-list-item col-xs-12 list-group"

        # Re-create the element name
        @setName()

        # Return nothing
        null
