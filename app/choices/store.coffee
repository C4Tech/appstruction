system = require "system"
actions = require "choices/actions"

class ChoicesStore
  constructor: ->
    @options = @getDefaultState()
    @bindActions actions
    @exportPublicMethods ->
      {getById: @getById}
    null

  @getById: (type, value) ->
    return choice for choice in @options[type]? when choice.value is value

  @getLabelFor: (type, value, quantity = 1) ->
    choice = @getById type, value
    return value unless choice
    label = choice.label
    label = choice.plural if choice.plural?
    label = choice.singular if quantity is 1 and choice.singular
    label

  getDefaultState: ->
    {
      concrete: [
          value: "1"
          label: "Sidewalk"
          singular: "Sidewalk"
          plural: "Sidewalks"
        ,
          value: "2"
          label: "Foundation"
          singular: "Foundation"
          plural: "Foundations"
        ,
          value: "3"
          label: "Curb"
          singular: "Curb"
          plural: "Curbs"
        ,
          value: "4"
          label: "Footings"
          singular: "Footing"
          plural: "Footings"
        ,
          value: "5"
          label: "Driveway"
          singular: "Driveway"
          plural: "Driveways"
      ]

      equipment: [
          value: "1"
          label: "Dump Truck"
          singular: "Dump Truck"
          plural: "Dump Trucks"
        ,
          value: "2"
          label: "Excavator"
          singular: "Excavator"
          plural: "Excavators"
        ,
          value: "3"
          label: "Bobcat"
          singular: "Bobcat"
          plural: "Bobcats"
        ,
          value: "4"
          label: "Concrete Pump"
          singular: "Concrete Pump"
          plural: "Concrete Pumps"
        ,
          value: "5"
          label: "Concrete Saw"
          singular: "Concrete Saw"
          plural: "Concrete Saws"
        ,
          value: "6"
          label: "Piles"
          singular: "Pile"
          plural: "Piles"
        ,
          value: "7"
          label: "Trial"
          singular: "Trial"
          plural: "Trials"
        ,
          value: "8"
          label: "Util Truck"
          singular: "Util Truck"
          plural: "Util Trucks"
        ,
          value: "9"
          label: "Trowel Machine"
          singular: "Trowel Machine"
          plural: "Trowel Machines"
      ]

      group: []

      job: [
          value: "1"
          label: "Municipal"
        ,
          value: "2"
          label: "Commercial"
        ,
          value: "3"
          label: "Residential"
        ,
          value: "4"
          label: "Civil"
        ,
          value: "5"
          label: "Structural"
      ]

      labor: [
          value: "1"
          label: "Finishers"
          singular: "Finisher"
          plural: "Finishers"
        ,
          value: "2"
          label: "Supervisors"
          singular: "Supervisor"
          plural: "Supervisors"
        ,
          value: "3"
          label: "Forms crp"
          singular: "Forms crp"
          plural: "Forms crp"
        ,
          value: "4"
          label: "Laborers"
          singular: "Laborer"
          plural: "Laborers"
        ,
          value: "5"
          label: "Driver"
          singular: "Driver"
          plural: "Drivers"
        ,
          value: "6"
          label: "Operator"
          singular: "Operator"
          plural: "Operators"
        ,
          value: "7"
          label: "Carpenter"
          singular: "Carpenter"
          plural: "Carpenters"
        ,
          value: "8"
          label: "Ironworker"
          singular: "Ironworker"
          plural: "Ironworkers"
      ]

      material: [
          value: "1"
          label: "Wire (sheet)"
          singular: "Wire"
          plural: "Wire"
        ,
          value: "2"
          label: "Keyway (lf)"
          singular: "Keyway"
          plural: "Keyways"
        ,
          value: "3"
          label: "Stakes (ea.)"
          singular: "Stake"
          plural: "Stakes"
        ,
          value: "4"
          label: "Cap (lf)"
          singular: "Cap"
          plural: "Caps"
        ,
          value: "5"
          label: "Dowells  (ea.)"
          singular: "Dowell"
          plural: "Dowells"
        ,
          value: "6"
          label: "2x8x20  (lf)"
          singular: "lf of 2x8x20"
          plural: "lf of 2x8x20"
        ,
          value: "7"
          label: "Misc"
          singular: "Misc"
          plural: "Misc"
      ]

      measurement: [
          value: "in"
          label: "Inches"
          singular: "Inch"
          plural: "Inches"
        ,
          value: "ft"
          label: "Feet"
          singular: "Foot"
          plural: "Feet"
        ,
          value:"yd"
          label: "Yards"
          singular: "Yard"
          plural: "Yards"
        ,
          value:"cm"
          label: "Centimeters"
          singular: "Centimeter"
          plural: "Centimeters"
        ,
          value:"m"
          label: "Meters"
          singular: "Meter"
          plural: "Meters"
      ]

      volume: [
          value: "in"
          label: "Cubic Inch"
          singular: "Cubic Inch"
          plural: "Cubic Inches"
        ,
          value: "ft"
          label: "Cubic Foot"
          singular: "Cubic Foot"
          plural: "Cubic Feet"
        ,
          value: "yd"
          label: "Cubic Yard"
          singular: "Cubic Yard"
          plural: "Cubic Yards"
        ,
          value: "cm"
          label: "Cubic Centimeter"
          singular: "Cubic Centimeter"
          plural: "Cubic Centimeters"
        ,
          value: "m"
          label: "Cubic Meter"
          singular: "Cubic Meter"
          plural: "Cubic Meters"
      ]

      time: [
          value: "hour"
          label: "Hours"
          singular: "Hour"
          plural: "Hours"
          per: "Hourly"
        ,
          value: "day"
          label: "Days"
          singular: "Day"
          plural: "Days"
          per: "Daily"
        ,
          value: "week"
          label: "Weeks"
          singular: "Week"
          plural: "Weeks"
          per: "Weekly"
        ,
          value: "month"
          label: "Months"
          singular: "Month"
          plural: "Months"
          per: "Monthly"
      ]
    }

  onCreate: (payload) ->
    grouping = @[payload.name]
    value = payload.data.value ? grouping.length + 1
    grouping.push
      value: "#{value}"
      label: "#{payload.data.label}"
      singular: "#{payload.data.singular}" ? "#{payload.data.label}"
      plural: "#{payload.data.plural}" ? "#{payload.data.label}s"

    @setState
      "#{payload.name}": grouping

module.exports = system.createStore ChoicesStore
