Model = require "models/base"

module.exports = class EquipmentModel extends Model
    defaults:
        "equipment_type": 1
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
            fieldType: "number"
            placeholder: "Quantity"
            name: "quantity"
            show: true
        ,
            fieldType: "number"
            placeholder: "Rate"
            name: "rate"
            show: true
        ,
            fieldType: "select"
            placeholder: "Equipment Type"
            name: "equipment_type"
            show: false
    ]

    initialize: ->
        @help = "Equipment help text"

    calculate: ->
        @cost = @attributes.quantity * @attributes.rate
        console.log "equipment row ##{@cid}: #{@attributes.quantity}@$#{@attributes.rate} = #{@cost}"
        @cost
