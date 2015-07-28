LabelLookup = require "util/label-lookup"

class TimeUtil extends LabelLookup
  # Assuming
  # - 8 hour day
  hoursInDay: 8
  # - 40 hour week
  daysInWeek: 5
  # - 160 hour month
  weeksInMonth: 4

  options:
    time: [
        value: "hour"
        label: "Hours"
      ,
        value: "day"
        label: "Days"
      ,
        value: "week"
        label: "Weeks"
      ,
        value: "month"
        label: "Months"
    ]

    rate: [
        value: "hour"
        label: "Hourly"
      ,
        value: "day"
        label: "Daily"
      ,
        value: "week"
        label: "Weekly"
      ,
        value: "month"
        label: "Monthly"
    ]

  getScale: (units) ->
    units ?= "hour"
    conversion = 1

    conversion *= @hoursInDay unless units is "hour"
    conversion *= @daysInWeek if units is "week" or units is "month"
    conversion *= @weeksInMonth if units is "month"

    conversion

  normalize: (value, units) ->
    value ?= 0
    units = @getScale units

    [value, units]

  toHours: (value, units) ->
    [quantity, unit] = @normalize value, units

    quantity*unit

  toPerHour: (value, units) ->
    [quantity, unit] = @normalize value, units

    quantity/unit

module.exports = new TimeUtil
