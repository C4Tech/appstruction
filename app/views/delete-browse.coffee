ChoicesSingleton = require "models/choices"
BaseView = require "views/base"

module.exports = class DeleteBrowseView extends BaseView
    initialize: (opts) ->
        @routeType = opts.routeType if opts.routeType?
        @template = require 'templates/delete-browse'

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
        @$('#delete-browse-jobs').select2
            minimumResultsForSearch: 6
            matcher: (term, optText, els) ->
                allText = optText + els[0].parentNode.getAttribute('label') or ''
                ('' + allText).toUpperCase().indexOf(('' + term).toUpperCase()) >= 0

        self = @
        @$('#delete-browse-jobs').click ->
            value = 'read.' + self.$(@).val()
            self.$('#delete-browse-button').data 'path', value

        # Return this
        @
