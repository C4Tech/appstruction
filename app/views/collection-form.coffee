CollectionView = require "views/collection"
ComponentFormView = require "views/component-form"

module.exports = class CollectionFormView extends CollectionView
  tagName: "article"

  # Our constructor
  initialize: (opts) ->
    # The class to use for auto-creating child views
    @child = ComponentFormView

    super opts

    @routeType = opts.routeType if opts.routeType?
    @id = "job-form-#{@routeType}"
    @className = "container #{@routeType}-form-collection"
    @multiple = switch @routeType
      when "create", "job" then false
      else true
    @step = opts.step if opts.step?
    @title = opts.title if opts.title?

    # Re-create the element name
    @setName()

    # Set template
    @template = require "templates/collection.form"

    # Return nothing
    null

  # Render the collection
  render: =>
    console.log "Rendering #{@routeType} collection"
    @_rendered = true

    # Remove anything already there
    @$el.empty()

    # Rebuild the frame
    @$el.html @template
      routeType: @routeType
      step: @step
      title: @title
      multiple: @multiple

    self = @
    # Append all of the rendered children
    _(@_children).each (child) =>
      @$(".items").append child.render().$el

      @$("input[type=number]").keyup ->
        val = self.$(@).val()

        # check if val starts with a period, if so append a "0" to the beginning
        if val.lastIndexOf('.', 0) == 0
          template = '.0000000000'
          if val == template.substring(0, val.length)
            return
          new_val = '0' + val
          self.$(@).val(new_val)

    # Apply select2 widget
    @$('select').select2
      allowClear: true
      minimumResultsForSearch: 6

    # Return this
    @
