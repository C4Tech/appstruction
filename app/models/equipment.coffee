Model = require "models/base"

module.exports = class EquipmentModel extends Model
    defaults:
        "type": 1
        "quantity": null
        "rate": null

    types: [
            id: "1"
            name: "Dump Truck"
        ,
            id: "2"
            name: "Excavator"
        ,
            id:"3"
            name: "Bobcat"
        ,
            id:"4"
            name: "C pump"
        ,
            id:"5"
            name: "Piles"
        ,
            id:"6"
            name: "Trial"
        ,
            id:"7"
            name: "Util Truck"
    ]

    fields: [
            type: "number"
            text: "Quantity"
            name: "quantity"
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
        @cost = @attributes.quantity * @attributes.rate
        console.log "equipment row ##{@cid}: #{@attributes.quantity}@$#{@attributes.rate} = #{@cost}"
        @cost
