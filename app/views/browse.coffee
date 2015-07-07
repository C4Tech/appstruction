Choices = require "models/choices"
BaseView = require "views/base"

module.exports = class BrowseView extends BaseView
  initialize: (opts) ->
    @routeType = opts.routeType
    @template = require "templates/browse"
    @className = "#{@routeType} container"
    @setName()
    null

  render: ->
    @$el.html @template
      jobGroups: Choices.get "jobGroups"

    # Apply select2 widget, enable filter by optgroups as well as options
    # https://github.com/ivaynberg/select2/issues/193
    @$("#browse-jobs").select2
      minimumResultsForSearch: 6
      matcher: (term, optText, els) ->
        label = els[0].parentNode.getAttribute "label"
        allText = "#{optText}#{label}"
        allText.toUpperCase().indexOf(("#{term}").toUpperCase()) >= 0

    @$("#browse-jobs").on "click", =>
      target = @$(event.currentTarget).val()
      @$("#browse-button").data "path", "read.#{target}"

    @
