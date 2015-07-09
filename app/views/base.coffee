# Backbone = require "backbone"

module.exports = class BaseView extends Backbone.View
  child: null
  container: null
  routeType: null
  self: null
  templateFile: null


  initialize: ->
    @self ?= @constructor
    @container ?= ".#{@routeType}-items"
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
