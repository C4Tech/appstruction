ComponentView = require "views/component"

module.exports = class JobListView extends ComponentView
  tagName: "li"

  initialize: (opts) ->
    @template = require "templates/job.list"
    super opts

    @className = "#{@routeType} #{@routeType}-list #{@routeType}-list-item
        list-group-item"
    @setName()

    null
