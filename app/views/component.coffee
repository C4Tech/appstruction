BaseView = require "views/base"

module.exports = class ComponentView extends BaseView
    _children: []

    events:
        "change input": "refresh"
        "change select": "refresh"

    initialize: ->
        @self = @constructor unless @self?
        @container = ".#{@type}-items" unless @container?
        @templateFile = "templates/create/#{@type}" unless @templateFile?
        @template = require @templateFile
        @prepare() if @model.cid?

    # Bind the view to the model
    prepare: ->
        @id = @model.cid
        _.bindAll @, "refresh" # Update the model when the input changes
        @listenTo @model, 'destroy', @remove # Remove the view/html when the model is destroyed
        @render()

    # Render the template
    render: ->
        @$el.html @template
            row: @model.toJSON()
            cid: @model.cid
        $(@container).append @$el
        $(@container).enhanceWithin()
        @

    # Event callback to add a new view on model creation
    addOne: (item) ->
        if not @_children[item.cid]
            console.log "Adding view"
            @_children[item.cid] = new @self
                model: item
        @_children[item.cid]

    # Event callback to update the model on input change
    refresh: (event) ->
        target = $ event.currentTarget
        @model.set target.attr('name'), target.val()
        console.log "View changed", target.attr('name'), target.val()
        $(".#{@type}.cost").text @model.collection.calculate()
        true
