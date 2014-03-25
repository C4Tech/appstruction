Model = require "models/base"

module.exports = class LaborModel extends Model
    defaults:
        "duration": null
        "labor_type": null
        "quantity": null
        "rate": null

    labor_type_options: [
            id: "1"
            text: "Finishers"
        ,
            id: "2"
            text: "Supervisors"
        ,
            id:"3"
            text: "Forms crp"
        ,
            id:"4"
            text: "Laborers"
        ,
            id:"5"
            text: "Driver"
        ,
            id:"6"
            text: "Operator"
    ]

    fields: [
            type: "select"
            placeholder: "Labor class"
            name: "labor_type"
            show: true
            fieldTypeSelect: true
            optionsType: 'labor_type'
        ,
            type: "number"
            placeholder: "Number of laborers"
            name: "laborers_count"
            show: true
        ,
            type: "number"
            placeholder: "Time per laborer"
            name: "labor_time"
            show: true
        ,
            type: "number"
            placeholder: "Unit"
            name: "unit"
            show: true
        ,
            type: "number"
            placeholder: "Rate"
            name: "rate"
            show: true
    ]

    initialize: ->
        @help = "Labor help text"

        self = @
        _(@fields).each (field) =>
            field.options = self.labor_type_options if field.optionsType == 'labor_type'

    calculate: ->
        @cost = @attributes.laborers_count * @attributes.labor_time * @attributes.rate
        console.log "labor row ##{@cid}: #{@attributes.laborers_count} x #{@attributes.labor_time}u @ $#{@attributes.rate} = #{@cost}"
        @cost
