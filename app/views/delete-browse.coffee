ChoicesSingleton = require "models/choices"
BaseView = require "views/base"
# Backbone = require "backbone"

module.exports = class DeleteBrowseView extends BaseView
  initialize: (opts) ->
    @routeType = opts.routeType if opts.routeType?
    @template = require "templates/delete-browse"
    @className = "#{@routeType} container"

    @setName()

    null

  render: ->
    @$el.html @template
      jobGroups: ChoicesSingleton.get "jobGroups"

    # Apply select2 widget, enable filter by optgroups as well as options
    # https://github.com/ivaynberg/select2/issues/193
    @$("#delete-job").select2
      minimumResultsForSearch: 6
      matcher: (term, optText, els) ->
        label = els[0].parentNode.getAttribute "label"
        allText = "#{optText}#{label}"
        allText.toUpperCase().indexOf(("#{term}").toUpperCase()) >= 0

    @$("#delete-group").select2
      minimumResultsForSearch: 6

    @$("#delete-job").click (event) =>
      @$("#delete-job-button").data
        path: "delete-job.#{data.id}"
        name: @$(event.currentTarget).select2("data")?.text

    @$("#delete-group").click (event) =>
      @$("#delete-group-button").data
        path: "delete-group.#{data.id}"
        name: @$(event.currentTarget).select2("data")?.text

    @$("#delete-job-button").click (event) =>
      event.preventDefault()
      name = @$(event.currentTarget).data "name"

      unless name
        bootbox.alert "No job estimate selected"
        null

      path = @$(event.currentTarget).data "path"
      bootbox.confirm "Delete the job estimate \"#{name}\"?", (result) ->
        Backbone.history.navigate path, true if result

    @$("#delete-group-button").click (event) ->
      e.preventDefault()
      name = self.$(event.currentTarget).data "name"

      unless name
        bootbox.alert "No group selected"
        return

      path = self.$(event.currentTarget).data "path"
      bootbox.confirm "Delete the group \"#{name}\" and all of it's jobs?",
        (result) ->
          Backbone.history.navigate path, true if result

    @
