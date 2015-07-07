class ConvertModel extends Backbone.Model
  # Assuming
  # - 8 hour day
  hoursInDay: 8
  # - 40 hour week
  daysInWeek: 5
  # - 160 hour month
  weeksInMonth: 4

  getScale: (units) ->
    units = units or "hour"
    conversion = 1

    conversion *= @hoursInDay unless units is "hour"
    conversion *= @daysInWeek if units is "week" or units is "month"
    conversion *= @weeksInMonth if units is "month"

    conversion

  normalize: (value, units) ->
    value = value or 0
    units = @getScale units

    [value, units]

  toHours: (value, units) ->
    [value, units] = normalize value, units

    value * units

  toPerHour: (value, units) ->
    [value, units] = normalize value, units

    value / conversion

module.exports = new ConvertModel
