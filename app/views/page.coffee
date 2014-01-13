FormView = require "views/form"

module.exports = class PageView extends Backbone.View
    tagName: "section"
    className: "page"

    title: "Cole"
    links: []
    back: null
    form: null
    article: null
    _subView: null

    initialize: (opts) ->
        @template = require "templates/page"
        @header = require "templates/header"
        @nav = require "templates/nav"

        @title = opts.title if opts.title?
        @back = opts.back if opts.back?
        @links = opts.links if opts.links?
        @article = opts.article if opts.article?
        @form = opts.form if opts.form?
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

        if @form
            console.log "Appending form view"
            @_subView = new FormView @form
            @$el.append @_subView.$el

        $("body").append @$el
        true
