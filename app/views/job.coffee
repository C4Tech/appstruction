ComponentView = require "views/component"

module.exports = class JobView extends ComponentView
    type: "job"

    # Render the template
    render: ->
        @$el.html @template
            row: @model.toJSON()
            cost: @model.cost
            cid: @model.cid
        $(@container).prepend @$el
        @

    # Event callback to update the model on input change
    refresh: (event) ->
        target = $ event.currentTarget
        @model.set target.attr('name'), target.val()
        console.log "View changed", target.attr('name'), target.val()
        $(".#{@type}.cost").text @model.calculate()
        true