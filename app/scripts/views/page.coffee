module.exports = class PageView extends Backbone.View
    tagName: "section"

    className: "page"

    article: null

    back: null

    links: []

    initialize: ->
        @template = require "templates/page"
        @header = require "templates/header"
        @render()
        true

    # Render the template
    render: ->
        header = @header
            title: @title
            back: @back

        nav = @nav
            links: @links

        @$el.html @template
            header: header
            nav: nav
            article: @article

        @$("body").html @$el
