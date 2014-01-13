module.exports = class FormView extends Backbone.View
    tagName: "article"

    className: "job-component"

    initialize: ->
        @template = require "templates/form"
        @render()
        true

    # Render the template
    render: ->
        @$el.html @template
            title: @title
            type: @type
            next: @url
        @$(".page").append @$el
        true
