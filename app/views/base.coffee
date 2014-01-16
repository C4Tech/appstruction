module.exports = class BaseView extends Backbone.View
    type: "component"

    self: null
    container: null
    templateFile: null

    _child: null

    initialize: ->
        @self = @constructor unless @self?
        @container = ".#{@type}-items" unless @container?
        @templateFile = "templates/create/#{@type}" unless @templateFile?
        @template = require @templateFile
        @render()

    render: ->
        @$el.html @template
        console.log "Rendering #{@type} into #{@container}"
        $(@container).append @$el
        @
