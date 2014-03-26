Model = require "models/base"

module.exports = class LaborModel extends Model
    defaults:
        "labor_time": null
        "labor_time_units": null
        "labor_type": null
        "laborers_count": null
        "rate": null
        "rate_units": null

    time_options: [
            id: "hour"
            text: "Hours"
        ,
            id: "day"
            text: "Days"
        ,
            id: "week"
            text: "Weeks"
        ,
            id: "month"
            text: "Months"
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

    labor_type_options: [
            id: "1"
            text: "Finishers"
        ,
            id: "2"
            text: "Supervisors"
        ,
            id:"3"
            text: "Forms crp"
        ,
            id:"4"
            text: "Laborers"
        ,
            id:"5"
            text: "Driver"
        ,
            id:"6"
            text: "Operator"
    ]

    fields: [
            type: "number"
            placeholder: "Time per laborer"
            name: "labor_time"
            show: true
        ,
            type: "select"
            placeholder: "Unit"
            name: "labor_time_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'time_units'
            append: '<hr />'
        ,
            type: "select"
            placeholder: "Labor class"
            name: "labor_type"
            show: true
            fieldTypeSelect: true
            optionsType: 'labor_type'
        ,
            type: "number"
            placeholder: "Number of laborers"
            name: "laborers_count"
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
        @help = "Labor help text"

        self = @
        _(@fields).each (field) =>
            field.options = self.labor_type_options if field.optionsType == 'labor_type'
            field.options = self.time_options if field.optionsType == 'time_units'
            field.options = self.time_per_options if field.optionsType == 'time_per_units'

    calculate: ->
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

        console.log "labor row ##{@cid}: #{labor_time} (#{labor_time_units}) x #{laborers_count} (laborers_count)  @ $#{rate} #{labor_time_units} = #{@cost}"
        @cost
