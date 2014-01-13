module.exports = class BaseView extends Backbone.View
    templateFile: ""
    self: null
    container: ""
    events:
        "change input": "refresh"
        "change select": "refresh"

    initialize: ->
        @prepare() if @model?
        true

    # Really flesh out the view
    prepare: ->
        _.bindAll @, "refresh" # Update the model when the input changes
        @listenTo @model, 'destroy', @remove # Remove the view/html when the model is destroyed
        @template = require "templates/#{@templateFile}"
        @render()
        res = @$(@container)
        console.log @container, res
        res.append @$el
        true

    # Event callback to add a new view on model creation
    addOne: (item) ->
        console.log "Adding view"
        view = new @self
            model: item
        true

    # Render the template
    render: ->
        @$el.html @template
            row: @model.toJSON()
            cid: @model.cid
        @

    # Event callback to update the model on input change
    refresh: (event) ->
        target = $ event.currentTarget
        @model.set target.attr('name'), target.val()
        console.log "View changed", target.attr('name'), target.val()
        true
