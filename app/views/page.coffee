module.exports = class PageView extends Backbone.View
    tagName: "section"
    className: "page"

    title: "Cole"
    links: []
    back: null
    form: null
    text: null
    subView: null

    initialize: (opts) ->
        @section = require "templates/page"
        @header = require "templates/header"
        @nav = require "templates/nav"

        @title = opts.title if opts.title?
        @back = opts.back if opts.back?
        @links = opts.links if opts.links?
        @text = opts.text if opts.text?
        @subView = opts.subView if opts.subView?
        true

    # Render the template
    render: ->
        @$el.empty()

        if @title? or @back?
            header = @header
                title: @title
                back: @back
            console.log "Rendering page header"
            @$el.append header

        if @links.length > 0
            nav = @nav
                links: @links
            console.log "Rendering page nav"
            @$el.append nav

        if @text?
            @$el.append @section
                text: @text
            console.log "Rendering page view"

        if @subView?
            console.log "Appending form view"
            @$el.append @subView.render().$el

        @
