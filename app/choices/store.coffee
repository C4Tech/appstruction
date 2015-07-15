system = require "system"
actions = require "choices/actions"

class ChoicesStore
  constructor: ->
    @options = @getDefaultState()
    @bindActions actions

    null

  getDefaultState: ->
    {
      concrete: [
          id: 1
          text: "Sidewalk"
          singular: "Sidewalk"
          plural: "Sidewalks"
        ,
          id: 2
          text: "Foundation"
          singular: "Foundation"
          plural: "Foundations"
        ,
          id: 3
          text: "Curb"
          singular: "Curb"
          plural: "Curbs"
        ,
          id: 4
          text: "Footings"
          singular: "Footing"
          plural: "Footings"
        ,
          id: 5
          text: "Driveway"
          singular: "Driveway"
          plural: "Driveways"
      ]

      equipment: [
          id: 1
          text: "Dump Truck"
          singular: "Dump Truck"
          plural: "Dump Trucks"
        ,
          id: 2
          text: "Excavator"
          singular: "Excavator"
          plural: "Excavators"
        ,
          id: 3
          text: "Bobcat"
          singular: "Bobcat"
          plural: "Bobcats"
        ,
          id: 4
          text: "Concrete Pump"
          singular: "Concrete Pump"
          plural: "Concrete Pumps"
        ,
          id: 5
          text: "Concrete Saw"
          singular: "Concrete Saw"
          plural: "Concrete Saws"
        ,
          id: 6
          text: "Piles"
          singular: "Pile"
          plural: "Piles"
        ,
          id: 7
          text: "Trial"
          singular: "Trial"
          plural: "Trials"
        ,
          id: 8
          text: "Util Truck"
          singular: "Util Truck"
          plural: "Util Trucks"
        ,
          id: 9
          text: "Trowel Machine"
          singular: "Trowel Machine"
          plural: "Trowel Machines"
      ]

      group: []

      job: [
          id: 1
          text: "Municipal"
        ,
          id: 2
          text: "Commercial"
        ,
          id: 3
          text: "Residential"
        ,
          id: 4
          text: "Civil"
        ,
          id: 5
          text: "Structural"
      ]

      labor: [
          id: 1
          text: "Finishers"
          singular: "Finisher"
          plural: "Finishers"
        ,
          id: 2
          text: "Supervisors"
          singular: "Supervisor"
          plural: "Supervisors"
        ,
          id: 3
          text: "Forms crp"
          singular: "Forms crp"
          plural: "Forms crp"
        ,
          id: 4
          text: "Laborers"
          singular: "Laborer"
          plural: "Laborers"
        ,
          id: 5
          text: "Driver"
          singular: "Driver"
          plural: "Drivers"
        ,
          id: 6
          text: "Operator"
          singular: "Operator"
          plural: "Operators"
        ,
          id: 7
          text: "Carpenter"
          singular: "Carpenter"
          plural: "Carpenters"
        ,
          id: 8
          text: "Ironworker"
          singular: "Ironworker"
          plural: "Ironworkers"
      ]

      material: [
          id: 1
          text: "Wire (sheet)"
          singular: "Wire"
          plural: "Wire"
        ,
          id: 2
          text: "Keyway (lf)"
          singular: "Keyway"
          plural: "Keyways"
        ,
          id: 3
          text: "Stakes (ea.)"
          singular: "Stake"
          plural: "Stakes"
        ,
          id: 4
          text: "Cap (lf)"
          singular: "Cap"
          plural: "Caps"
        ,
          id: 5
          text: "Dowells  (ea.)"
          singular: "Dowell"
          plural: "Dowells"
        ,
          id: 6
          text: "2x8x20  (lf)"
          singular: "lf of 2x8x20"
          plural: "lf of 2x8x20"
        ,
          id: 7
          text: "Misc"
          singular: "Misc"
          plural: "Misc"
      ]

      measurement: [
          id: "in"
          text: "Inches"
          singular: "Inch"
          plural: "Inches"
        ,
          id: "ft"
          text: "Feet"
          singular: "Foot"
          plural: "Feet"
        ,
          id:"yd"
          text: "Yards"
          singular: "Yard"
          plural: "Yards"
        ,
          id:"cm"
          text: "Centimeters"
          singular: "Centimeter"
          plural: "Centimeters"
        ,
          id:"m"
          text: "Meters"
          singular: "Meter"
          plural: "Meters"
      ]

      volume: [
          id: "in"
          text: "Cubic Inch"
          singular: "Cubic Inch"
          plural: "Cubic Inches"
        ,
          id: "ft"
          text: "Cubic Foot"
          singular: "Cubic Foot"
          plural: "Cubic Feet"
        ,
          id: "yd"
          text: "Cubic Yard"
          singular: "Cubic Yard"
          plural: "Cubic Yards"
        ,
          id: "cm"
          text: "Cubic Centimeter"
          singular: "Cubic Centimeter"
          plural: "Cubic Centimeters"
        ,
          id: "m"
          text: "Cubic Meter"
          singular: "Cubic Meter"
          plural: "Cubic Meters"
      ]

      time: [
          id: "hour"
          text: "Hours"
          singular: "Hour"
          plural: "Hours"
          per: "Hourly"
        ,
          id: "day"
          text: "Days"
          singular: "Day"
          plural: "Days"
          per: "Daily"
        ,
          id: "week"
          text: "Weeks"
          singular: "Week"
          plural: "Weeks"
          per: "Weekly"
        ,
          id: "month"
          text: "Months"
          singular: "Month"
          plural: "Months"
          per: "Monthly"
      ]
    }

  onCreate: (payload) ->
    @[payload.name].push
      id: payload.data.id ? @[payload.name].length + 1
      text: payload.data.text
      singular: payload.data.singular ? payload.data.text
      plural: payload.data.plural ? "#{payload.data.text}s"

    null

module.exports = system.createStore ChoicesStore
