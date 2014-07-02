BaseModel = require "models/base"
ChoicesSingleton = require "models/choices"
ConvertModel = require "models/convert"

module.exports = class EquipmentModel extends BaseModel
    defaults:
        "equipment_time": null
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
            name: "equipment_time"
            show: true
    ]

    initialize: ->
        @help = "Equipment help text"
        super

    calculate: ->
        equipment_type = @attributes.equipment_type ? ''

        convert = new ConvertModel

        time = convert.to_hours @attributes.equipment_time, @attributes.rate_units
        rate = convert.to_per_hour @attributes.rate, @attributes.rate_units

        quantity = @attributes.quantity ? 0

        @cost = time * rate * quantity
        console.log "equipment row (#{equipment_type}) ##{@cid}: #{time} (#{@attributes.rate_units}) x #{quantity} (quantity) @ $#{rate} (#{@attributes.rate_units}) = #{@cost}"
        @cost

    overview: ->
        no_equipment = ['No equipment']
        equipment_type_display = ChoicesSingleton.get 'equipment_type_options_display'
        time_options_display = ChoicesSingleton.get 'time_options_display'

        equipment_type_key = @attributes.equipment_type ? 'dump truck'
        equipment_time = parseFloat(@attributes.equipment_time) ? 0
        rate_key = @attributes.rate_units ? 'hour'

        quantity = parseFloat(@attributes.quantity) ? 0
        equipment_time = parseFloat(@attributes.equipment_time) ? 0
        rate = parseFloat(@attributes.rate) ? 0

        if isNaN(quantity) or quantity == 0
            return no_equipment
        else if isNaN(equipment_time) or equipment_time == 0
            return no_equipment
        else if isNaN(rate) or rate == 0
            return no_equipment

        # round values to no more than 2 decimals
        quantity = Math.round(quantity * 100) / 100
        equipment_time = Math.round(equipment_time * 100) / 100

        noun_type = 'singular'
        if quantity > 1
            noun_type = 'plural'
        equipment_type = equipment_type_display[noun_type][equipment_type_key]
        unless equipment_type?
            equipment_type= ChoicesSingleton.getTextById('equipment_type_options', equipment_type_key).toLowerCase()

        noun_type = 'singular'
        if equipment_time > 1
            noun_type = 'plural'
        equipment_time_unit = time_options_display[noun_type][rate_key]

        rate_unit = time_options_display['singular'][rate_key]

        equipment_item = "#{quantity} #{equipment_type} for #{equipment_time} #{equipment_time_unit} @ $#{rate}/#{rate_unit}"

        return [
            equipment_item,
        ]
