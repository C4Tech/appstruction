ComponentView = require "views/component"

module.exports = class JobListView extends ComponentView
    tagName: "li"

    initialize: (opts) ->
        super opts

        # Set template
        @template = require "templates/job.list"

        # Add attributes
        @className = "#{@type} #{@type}-list #{@type}-list-item list-group-item"

        # Re-create the element name
        @setName()

        # Return nothing
        null
