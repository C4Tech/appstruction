module.exports = class LaborView extends Backbone.View
    initialize: ->
        @render()
    render: ->
        template = require "templates/labor.row"
        @el.html template 
            row: @row
            labor: @model.toJSON()
