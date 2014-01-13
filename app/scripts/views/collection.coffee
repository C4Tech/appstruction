module.exports = class CollectionView extends Backbone.View
    tagName: "article"

    className: "job-component"

    initialize: ->
        @id = @type
        @template = require "templates/collection"
        @render()
        true

    # Render the template
    render: ->
        @$el.html @template
            title: @title
            type: @type
            next: @url
        @$("section.page").html @$el
