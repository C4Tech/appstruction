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
        @$el.html @template
            job_groups: ChoicesSingleton.get 'job_groups'

        # Apply select2 widget, enable filter by optgroups as well as options
        @$('select').select2
            minimumResultsForSearch: 6
            matcher: (term, optText, els) ->
                allText = optText + els[0].parentNode.getAttribute('label') or ''
                ('' + allText).toUpperCase().indexOf(('' + term).toUpperCase()) >= 0

        # Return this
        @
