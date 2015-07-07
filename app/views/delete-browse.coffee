ChoicesSingleton = require "models/choices"
BaseView = require "views/base"

module.exports = class DeleteBrowseView extends BaseView
  initialize: (opts) ->
    @routeType = opts.routeType if opts.routeType?
    @template = require 'templates/delete-browse'

    # Add attributes
    @className = "#{@routeType} container"

    # Re-create the element name
    @setName()

    # Return nothing
    null

  render: ->
    @$el.html @template
      job_groups: ChoicesSingleton.get 'job_groups'

    # Apply select2 widget, enable filter by optgroups as well as options
    # https://github.com/ivaynberg/select2/issues/193
    @$('#delete-job').select2
      minimumResultsForSearch: 6
      matcher: (term, optText, els) ->
        allText = optText + els[0].parentNode.getAttribute('label') or ''
        ('' + allText).toUpperCase().indexOf(('' + term).toUpperCase()) >= 0

    @$('#delete-group').select2
      minimumResultsForSearch: 6

    self = @
    @$('#delete-job').click ->
      data = self.$(@).select2('data')
      value = 'delete-job.' + data.id
      self.$('#delete-job-button').data('path', value).data('name', data.text)

    @$('#delete-group').click ->
      data = self.$(@).select2('data')
      value = 'delete-group.' + data.id
      self.$('#delete-group-button').data('path', value).data('name', data.text)

    @$('#delete-job-button').click (e) ->
      e.preventDefault()
      name = self.$(@).data('name')

      unless !!name
        bootbox.alert "No job estimate selected"
        return

      path = self.$(@).data('path')
      bootbox.confirm "Delete the job estimate '#{name}'?", (result) ->
        if result
          Backbone.history.navigate(path, true)

    @$('#delete-group-button').click (e) ->
      e.preventDefault()
      name = self.$(@).data('name')

      unless !!name
        bootbox.alert "No group selected"
        return

      path = self.$(@).data('path')
      bootbox.confirm "Delete the group '#{name}' and all of it's jobs?", (result) ->
        if result
          Backbone.history.navigate(path, true)

    # Return this
    @
