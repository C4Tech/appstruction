ChoicesSingleton = require "models/choices"
BaseView = require "views/base"

module.exports = class BrowseView extends BaseView
    initialize: (opts) ->
        @routeType = opts.routeType if opts.routeType?
        @template = require 'templates/browse'

        # Add attributes
        @className = @routeType

        # Re-create the element name
        @setName()

        # Return nothing
        null

    render: ->
        job_groups = ChoicesSingleton.get 'job_groups'

        @$el.html @template
            job_groups: job_groups

        # Return this
        @
