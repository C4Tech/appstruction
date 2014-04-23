module.exports = class PageView extends Backbone.View
    tagName: "section"
    className: "page"

    title: "Cole"
    text: null
    subView: null

    initialize: (opts) ->
        @section = require "templates/page"
        @header = require "templates/header"

        @title = opts.title if opts.title?
        @text = opts.text if opts.text?
        @subView = opts.subView if opts.subView?
        true

    # Render the template
    render: ->
        @$el.empty()

        if @title?
            header = @header
                title: @title
                step: @subView?.step ? null
            console.log "Rendering page header"
            @$el.append header

        if @text?
            @$el.append @section
                text: @text
            console.log "Rendering page view"

        if @subView?
            console.log "Appending form view"
            @$el.append @subView.render().$el

        @
