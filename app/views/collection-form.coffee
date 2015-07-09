CollectionView = require "views/collection"
ComponentFormView = require "views/component-form"
# _ = require "underscore"

module.exports = class CollectionFormView extends CollectionView
  tagName: "article"

  initialize: (opts) ->
    @child = ComponentFormView
    @multiple = true
    @step = opts.step
    @template = require "templates/collection.form"
    @title = opts.title
    super opts

    @className = "container #{@routeType}-form-collection"
    @id = "job-form-#{@routeType}"
    @multiple = false if @routeType is "create" or @routeType is "job"
    @setName()
    null

  render: =>
    console.log "Rendering #{@routeType} collection"
    @rendered = true

    @$el.empty()

    @$el.html @template
      routeType: @routeType
      step: @step
      title: @title
      multiple: @multiple

    _(@children).each (child) =>
      @$(".items").append child.render().$el

      @$("input[type=number]").keyup (event) =>
        target = @$ event.currentTarget
        val = target.val()

        if val.lastIndexOf ".", 0 is 0
          template = ".0000000000"
          null if val is template.substring 0, val.length
          target.val "0#{val}"

    @$("select").select2
      allowClear: true
      minimumResultsForSearch: 6

    @
