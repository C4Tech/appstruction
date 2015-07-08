# Backbone = require "backbone"

module.exports = class PageView extends Backbone.View
  tagName: "section"
  className: "page"

  title: "Concrete Estimator"
  text: null
  subView: null

  initialize: (opts) ->
    @section = require "templates/page"
    @header = require "templates/header"
    @title = opts.title if opts.title?
    @text = opts.text if opts.text?
    @subView = opts.subView if opts.subView?

    null

  render: ->
    @$el.empty()
    @renderHeader() if @title?
    @renderPage() if @text?
    @renderSubView() if @subView?

    @

  renderHeader: ->
    header = @header
      title: @title
      step: @subView?step ? null
    console.log "Rendering page header"
    @$el.append header

    null

  renderPage: ->
    console.log "Rendering page view"
    @$el.append @section
      text: @text

    null

  renderSubView: ->
    console.log "Appending form view"
    @$el.append @subView.render().$el

    null
