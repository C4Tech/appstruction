Model = require "models/base"
ConvertModel = require "models/convert"

module.exports = class EquipmentModel extends Model
    defaults: _.extend Model.prototype.defaults,
        "time": null
        "time_units": null
        "equipment_type": null
        "quantity": null
        "rate": null
        "rate_units": null

    fields: [
            fieldType: "number"
            placeholder: "Time used"
            name: "time"
            show: true
        ,
            fieldType: "select"
            placeholder: "Unit"
            name: "time_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'time_units'
            append: '<hr />'
        ,
            fieldType: "select"
            placeholder: "Equipment Type"
            name: "equipment_type"
            show: true
            fieldTypeSelect: true
            optionsType: 'equipment_type'
        ,
            fieldType: "number"
            placeholder: "How many"
            name: "quantity"
            show: true
        ,
            fieldType: "number"
            placeholder: "What rate"
            name: "rate"
            show: true
        ,
            fieldType: "select"
            placeholder: "Unit"
            name: "rate_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'time_per_units'
    ]

    initialize: ->
        @help = "Equipment help text"

        return if not @attributes.choices.attributes

        choices = @attributes.choices.attributes
        _(@fields).each (field) =>
            field.options = choices.equipment_type_options if field.optionsType == 'equipment_type'
            field.options = choices.time_options if field.optionsType == 'time_units'
            field.options = choices.time_per_options if field.optionsType == 'time_per_units'

    calculate: ->
        convert = new ConvertModel

        time = convert.to_hours @attributes.time, @attributes.time_units
        rate = convert.to_per_hour @attributes.rate, @attributes.rate_units

        quantity = @attributes.quantity ? 0

        @cost = time * rate * quantity
        console.log "equipment row ##{@cid}: #{time} (#{@attributes.time_units}) x #{quantity} (quantity) @ $#{rate} (#{@attributes.time_units}) = #{@cost}"
        @cost
