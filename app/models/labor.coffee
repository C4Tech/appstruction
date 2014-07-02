BaseModel = require "models/base"
ChoicesSingleton = require "models/choices"

module.exports = class LaborModel extends BaseModel
    defaults:
        "labor_time": null
        "labor_time_units": null
        "labor_type": null
        "laborers_count": null
        "rate": null
        "rate_units": null

    fields: [
            fieldType: "hidden"
            label: "Labor class"
            name: "labor_type"
            show: true
            optionsType: 'labor_type_options'
            append: '<hr />'
        ,
            fieldType: "number"
            label: "Number of laborers"
            name: "laborers_count"
            show: true
        ,
            fieldType: "number"
            label: "Time per laborer"
            name: "labor_time"
            show: true
            hasSiblingField: true
        ,
            fieldType: "select"
            placeholder: "Unit"
            name: "labor_time_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'time_options'
        ,
            fieldType: "number"
            label: "Pay Rate"
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
        @help = "Labor help text"
        super

    calculate: ->
        labor_type = @attributes.labor_type ? ''
        labor_time_value = @attributes.labor_time ? 0
        labor_time_units = @attributes.labor_time_units ? 'hour'

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

        rate_value = @attributes.rate ? 0
        rate_units = @attributes.rate_units ? 'hour'

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

        laborers_count = @attributes.laborers_count ? 0

        @cost = labor_time * rate * laborers_count

        console.log "labor row (#{labor_type}) ##{@cid}: #{labor_time} (#{labor_time_units}) x #{laborers_count} (laborers_count)  @ $#{rate} #{labor_time_units} = #{@cost}"
        @cost

    overview: ->
        no_labor = ['No labor']
        labor_type_display = ChoicesSingleton.get 'labor_type_options_display'
        time_options_display = ChoicesSingleton.get 'time_options_display'

        labor_type_key = @attributes.labor_type ? '1'
        labor_time_key = @attributes.labor_time_units ? 'hour'
        rate_key = @attributes.rate_units ? 'hour'

        laborers_count = parseFloat(@attributes.laborers_count) ? 0
        labor_time = parseFloat(@attributes.labor_time) ? 0
        rate = parseFloat(@attributes.rate) ? 0

        if isNaN(laborers_count) or laborers_count == 0
            return no_labor
        else if isNaN(labor_time) or labor_time == 0
            return no_labor
        else if isNaN(rate) or rate == 0
            return no_labor

        # round values to no more than 2 decimals
        laborers_count = Math.round(laborers_count * 100) / 100
        labor_time = Math.round(labor_time * 100) / 100
        rate = Math.round(rate * 100) / 100

        noun_type = 'singular'
        if laborers_count > 1
            noun_type = 'plural'
        labor_type = labor_type_display[noun_type][labor_type_key]
        unless labor_type?
            labor_type = ChoicesSingleton.getTextById('labor_type_options', labor_type_key).toLowerCase()

        noun_type = 'singular'
        if labor_time > 1
            noun_type = 'plural'
        labor_time_unit = time_options_display[noun_type][labor_time_key]

        rate_unit = time_options_display['singular'][rate_key]

        laborer_item = "#{laborers_count} #{labor_type} for #{labor_time} #{labor_time_unit} @ $#{rate}/#{rate_unit}"

        return [
            laborer_item,
        ]
