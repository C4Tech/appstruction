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
            type: "number"
            text: "Project duration"
            name: "duration"
            show: true
        ,
            type: "select"
            text: "Type"
            name: "type"
            show: false
        ,
            type: "number"
            text: "Quantity"
            name: "quantity"
            show: true
        ,
            type: "number"
            text: "Rate"
            name: "rate"
            show: true
    ]

    initialize: ->
        @help = "Labor help text"

    calculate: ->
        @cost = @attributes.duration * @attributes.quantity * @attributes.rate
        console.log "labor row ##{@cid}: #{@attributes.duration} x #{@attributes.quantity}u @ $#{@attributes.rate} = #{@cost}"
        @cost
