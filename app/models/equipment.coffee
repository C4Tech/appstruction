BaseModel = require "models/base"
ConvertModel = require "models/convert"

module.exports = class EquipmentModel extends BaseModel
    defaults:
        "time": null
        "time_units": null
        "equipment_type": null
        "quantity": null
        "rate": null
        "rate_units": null

    fields: [
            fieldType: "number"
            label: "Time used"
            name: "time"
            show: true
            hasSiblingField: true
        ,
            fieldType: "select"
            placeholder: "Unit"
            name: "time_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'time_options'
            append: '<hr />'
        ,
            fieldType: "hidden"
            label: "Equipment Type"
            name: "equipment_type"
            show: true
            optionsType: 'equipment_type_options'
            append: '<br /><br />'
        ,
            fieldType: "number"
            label: "How many"
            name: "quantity"
            show: true
        ,
            fieldType: "number"
            label: "What rate"
            name: "rate"
            show: true
            hasSiblingField: true
        ,
            fieldType: "select"
            placeholder: "Unit"
            name: "rate_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'time_per_options'
    ]

    initialize: ->
        @help = "Equipment help text"
        super

    calculate: ->
        convert = new ConvertModel

        time = convert.to_hours @attributes.time, @attributes.time_units
        rate = convert.to_per_hour @attributes.rate, @attributes.rate_units

        quantity = @attributes.quantity ? 0

        @cost = time * rate * quantity
        console.log "equipment row ##{@cid}: #{time} (#{@attributes.time_units}) x #{quantity} (quantity) @ $#{rate} (#{@attributes.time_units}) = #{@cost}"
        @cost
