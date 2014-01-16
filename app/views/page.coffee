FormView = require "views/form"

module.exports = class PageView extends Backbone.View
    tagName: "section"
    className: "page"

    title: "Cole"
    links: []
    back: null
    form: null
    article: null
    _content: null

    initialize: (opts) ->
        @template = require "templates/page"
        @header = require "templates/header"
        @nav = require "templates/nav"

        @title = opts.title if opts.title?
        @back = opts.back if opts.back?
        @links = opts.links if opts.links?
        @article = opts.article if opts.article?
        @_content = opts.content if opts.content?
        @render()
        true

    # Render the template
    render: ->
        header = @header
            title: @title
            back: @back
        console.log "Rendering page header"
        @$el.html header

        nav = @nav
            links: @links
        console.log "Rendering page nav"
        @$el.append nav

        @$el.append @template
            article: @article
        console.log "Rendering page view"

        if @_content?
            console.log "Appending form view"
            @$el.append @_content.$el

        @
