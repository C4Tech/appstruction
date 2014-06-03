BaseModel = require "models/base"
ConvertModel = require "models/convert"

module.exports = class EquipmentModel extends BaseModel
    defaults:
        "time": null
        "equipment_type": null
        "quantity": null
        "rate": null
        "rate_units": null

    fields: [
            fieldType: "hidden"
            label: "Equipment Type"
            name: "equipment_type"
            show: true
            optionsType: 'equipment_type_options'
            append: '<br />'
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
        ,
            fieldType: "number"
            label: "Time used"
            name: "time"
            show: true
    ]

    initialize: ->
        @help = "Equipment help text"
        super

    calculate: ->
        convert = new ConvertModel

        time = convert.to_hours @attributes.time, @attributes.rate_units
        rate = convert.to_per_hour @attributes.rate, @attributes.rate_units

        quantity = @attributes.quantity ? 0

        @cost = time * rate * quantity
        console.log "equipment row ##{@cid}: #{time} (#{@attributes.rate_units}) x #{quantity} (quantity) @ $#{rate} (#{@attributes.rate_units}) = #{@cost}"
        @cost
