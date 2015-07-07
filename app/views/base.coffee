module.exports = class BaseView extends Backbone.View
  routeType: null
  self: null
  container: null
  templateFile: null

  _child: null

  initialize: ->
    @self = @constructor unless @self?
    @container = ".#{@routeType}-items" unless @container?
    null

  render: ->
    @$el.html @template
    console.log "Rendering #{@routeType} into #{@container}"
    $(@container).append @$el
    @

  # Re-create the element name
  setName: ->
    @$el.remove()
    delete @el
    @_ensureElement()
    null
