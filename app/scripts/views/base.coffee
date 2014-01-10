module.exports = class BaseView extends Backbone.View
    templateFile: ""
    events:
        "change input": "refresh"
        "change select": "refresh"

    initialize: ->
        _.bindAll @, "refresh" # Update the model when the input changes
        # @listenTo @model, 'change', @render
        # @listenTo @model, 'destroy', @remove
        @template = require "templates/#{@templateFile}"
        @render()

    render: ->
        @$el.html @template
            row: @model.toJSON()
            cid: @model.cid
        @

    refresh: (event) ->
        target = $ event.currentTarget
        @model.set target.attr('name'), target.val()
        true
