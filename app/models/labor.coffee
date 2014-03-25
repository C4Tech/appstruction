Model = require "models/base"

module.exports = class LaborModel extends Model
    defaults:
        "duration": null
        "type": null
        "quantity": null
        "rate": null

    types: [
            id: "1"
            name: "Finishers"
        ,
            id: "2"
            name: "Supervisors"
        ,
            id:"3"
            name: "Forms crp"
        ,
            id:"4"
            name: "Laborers"
        ,
            id:"5"
            name: "Driver"
        ,
            id:"6"
            name: "Operator"
    ]

    fields: [
            type: "select"
            placeholder: "Type"
            name: "type"
            show: false
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

    calculate: ->
        @cost = @attributes.laborers_count * @attributes.labor_time * @attributes.rate
        console.log "labor row ##{@cid}: #{@attributes.laborers_count} x #{@attributes.labor_time}u @ $#{@attributes.rate} = #{@cost}"
        @cost
