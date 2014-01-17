Model = require "models/base"

module.exports = class LaborModel extends Model
    defaults: 
        "type": 1
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
            type: "number"
            text: "Number"
            name: "number"
            show: true
        ,
            type: "number"
            text: "Unit"
            name: "unit"
            show: true
        ,
            type: "number"
            text: "Rate"
            name: "rate"
            show: true
        ,
            type: "select"
            text: "Type"
            name: "type"
            show: false
    ]

    calculate: ->
        @cost = @attributes.number * @attributes.rate * @attributes.unit
        console.log "labor row ##{@cid}: #{@attributes.number} x #{@attributes.unit}u @ $#{@attributes.rate} = #{@cost}"
        @cost
