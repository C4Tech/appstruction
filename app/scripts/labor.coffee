LaborModel = require "scripts/labor.model"
LaborView = require "scripts/labor.view"

class Labor
    view: {}
    model: {}
    count: 0

    get: (row = false, validate = false) ->
        @model = false
        lastRow = $$(".labor.subdiv").last().id
        row = lastRow.match /[0-9]+$/ unless row
        @_load row

        if (validate and !@model.isValid())
            alert @model.validationError
            @model = false

        @model

    reset: (row = false) ->
        row = @count unless row
        $$("#labor_number_#{row}").val null
        $$("#labor_unit_#{row}").val null
        $$("#labor_rate_#{row}").val null
        @_load row
        @view.model = @model
        true

    calculate = ->
        $$("#showcalculationlabor").text @calculate()
        true

    create: ->
        @_new()
        @_show()
        $$("#labor_subtotals").append @view.el
        true

    _new: ->
        @model = new LaborModel
            number: null
            unit: null
            rate : null

        @count++
        true

    _load: (row = false) ->
        row = @count unless row
        @model = new LaborModel
            number: $$("#labor_number_#{row}").val()
            unit: $$("#labor_unit_#{row}").val()
            rate : $$("#labor_rate_#{row}").val()
        @view = new LaborView
            model: @model
        true

    _show: (row = false) ->
        row = @count unless row
        @view = new LaborView
            model: @model
            id: "labor_subdiv_#{row}"
            className: "labor subdiv form"
        true

    _calculateRow: (row = false) ->
        row = @count unless row
        quantity = $$("#labor_number_#{row}").val()
        unit = $$("#labor_unit_#{row}").val()
        rate = $$("#labor_rate_#{row}").val()
        cost = quantity * rate * unit
        console.log "labor row ##{row}: #{quantity} (#{unit}) @ #{rate} = #{cost}"
        cost

    _calculateAll = ->
        total = 0
        total += @_calculateRow(idx) for idx in [0...@count+1]
        console.log "labor total", total
        total

module.exports = new Labor
