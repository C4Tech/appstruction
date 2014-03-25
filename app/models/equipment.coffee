Model = require "models/base"

module.exports = class EquipmentModel extends Model
    defaults:
        "type": null
        "quantity": null
        "rate": null
        "rate_units": null

    equipment_type_options: [
            id: "1"
            text: "Dump Truck"
        ,
            id: "2"
            text: "Excavator"
        ,
            id:"3"
            text: "Bobcat"
        ,
            id:"4"
            text: "C pump"
        ,
            id:"5"
            text: "Piles"
        ,
            id:"6"
            text: "Trial"
        ,
            id:"7"
            text: "Util Truck"
    ]

    time_per_options: [
            id: "hour"
            text: "Hourly"
        ,
            id: "day"
            text: "Daily"
        ,
            id: "week"
            text: "Weekly"
        ,
            id: "month"
            text: "Monthly"
    ]

    fields: [
            type: "select"
            placeholder: "Equipment Type"
            name: "equipment_type"
            show: true
            fieldTypeSelect: true
            optionsType: 'equipment_type'
        ,
            type: "number"
            placeholder: "Quantity"
            name: "quantity"
            show: true
        ,
            type: "number"
            placeholder: "Rate"
            name: "rate"
            show: true
        ,
            type: "select"
            placeholder: "Unit"
            name: "rate_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'time_per_units'
    ]

    initialize: ->
        @help = "Equipment help text"

        self = @
        _(@fields).each (field) =>
            field.options = self.equipment_type_options if field.optionsType == 'equipment_type'
            field.options = self.time_per_options if field.optionsType == 'time_per_units'

    calculate: ->
        @cost = @attributes.quantity * @attributes.rate
        console.log "equipment row ##{@cid}: #{@attributes.quantity}@$#{@attributes.rate} = #{@cost}"
        @cost
