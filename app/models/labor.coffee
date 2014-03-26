Model = require "models/base"
ChoicesModel = require "models/choices"

module.exports = class LaborModel extends Model
    defaults:
        "labor_time": null
        "labor_time_units": null
        "labor_type": null
        "laborers_count": null
        "rate": null
        "rate_units": null


    fields: [
            fieldType: "number"
            placeholder: "Time per laborer"
            name: "labor_time"
            show: true
        ,
            fieldType: "select"
            placeholder: "Unit"
            name: "labor_time_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'time_units'
            append: '<hr />'
        ,
            fieldType: "hidden"
            placeholder: "Labor class"
            name: "labor_type"
            show: true
            optionsType: 'labor_type'
            append: '<br /><br />'
        ,
            fieldType: "number"
            placeholder: "Number of laborers"
            name: "laborers_count"
            show: true
        ,
            fieldType: "number"
            placeholder: "Rate"
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
        @help = "Labor help text"

        choices = new ChoicesModel().attributes
        _(@fields).each (field) =>
            field.options = choices.labor_type_options if field.optionsType == 'labor_type'
            field.options = choices.time_options if field.optionsType == 'time_units'
            field.options = choices.time_per_options if field.optionsType == 'time_per_units'

    calculate: ->
        labor_time_value = @attributes.labor_time || 0
        labor_time_units = @attributes.labor_time_units || 'hour'

        # Assuming
        # - 8 hour day
        # - 40 hour week
        # - 160 hour month

        # Convert to hours
        if labor_time_units == 'hour'
            labor_time_conversion = 1
        else if labor_time_units == 'day'
            labor_time_conversion = 8
        else if labor_time_units == 'week'
            labor_time_conversion = 40
        else if labor_time_units == 'month'
            labor_time_conversion = 160

        labor_time = labor_time_value * labor_time_conversion

        rate_value = @attributes.rate || 0
        rate_units = @attributes.rate_units || 'hour'

        # Convert to per hour
        rate = rate_value
        if rate_units == 'hour'
            rate_conversion = 1
        else if rate_units == 'day'
            rate_conversion = 8
        else if rate_units == 'week'
            rate_conversion = 40
        else if rate_units == 'month'
            rate_conversion = 160

        rate = rate_value / rate_conversion

        laborers_count = @attributes.laborers_count || 0

        @cost = labor_time * rate * laborers_count

        console.log "labor row ##{@cid}: #{labor_time} (#{labor_time_units}) x #{laborers_count} (laborers_count)  @ $#{rate} #{labor_time_units} = #{@cost}"
        @cost
