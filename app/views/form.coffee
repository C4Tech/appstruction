module.exports = class FormView extends Backbone.View
    tagName: "article"
    className: "job-component"
    container: ".page"
    multiple: true

    initialize: (opts) ->
        @template = require "templates/form"
        
        @type = opts.type if opts.type?
        @title = opts.title if opts.title?
        @next = opts.next if opts.next?
        @container = opts.container if opts.container?
        @id = "job-form-#{@type}" unless opts.id?
        @multiple = false if @type is "type" or @type is "job" or @type is "concrete"
        @render()

    # Render the template
    render: ->
        @$el.html @template
            title: @title
            type: @type
            next: @next
            multiple: @multiple
        @
