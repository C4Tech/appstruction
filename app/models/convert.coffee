module.exports = class ConvertModel extends Backbone.Model
    to_hours: (value, units) ->
        value = value || 0
        units = units || 'hour'

        # Assuming
        # - 8 hour day
        # - 40 hour week
        # - 160 hour month

        if units == 'hour'
            conversion = 1
        else if units == 'day'
            conversion = 8
        else if units == 'week'
            conversion = 40
        else if units == 'month'
            conversion = 160

        return value * conversion

    to_per_hour: (value, units) ->
        value = value || 0
        units = units || 'hour'

        # Convert to per hour
        if units == 'hour'
            conversion = 1
        else if units == 'day'
            conversion = 8
        else if units == 'week'
            conversion = 40
        else if units == 'month'
            conversion = 160

        return value / conversion
