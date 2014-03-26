Model = require "models/base"

module.exports = class LaborModel extends Model
    defaults: 
        "labor_type": 1
        "number": null
        "unit": null
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
            fieldType: "number"
            placeholder: "Number"
            name: "number"
            show: true
        ,
            fieldType: "number"
            placeholder: "Unit"
            name: "unit"
            show: true
        ,
            fieldType: "number"
            placeholder: "Rate"
            name: "rate"
            show: true
        ,
            fieldType: "select"
            placeholder: "Labor Type"
            name: "labor_type"
            show: false
    ]

    initialize: ->
        @help = "Labor help text"

    calculate: ->
        @cost = @attributes.number * @attributes.rate * @attributes.unit
        console.log "labor row ##{@cid}: #{@attributes.number} x #{@attributes.unit}u @ $#{@attributes.rate} = #{@cost}"
        @cost
