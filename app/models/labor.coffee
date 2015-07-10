BaseModel = require "models/base"
Choices = require "models/choices"
convert = require "models/convert"

module.exports = class LaborModel extends BaseModel
  defaults:
    laborTime: null
    laborTimeUnits: null
    laborType: null
    laborersCount: null
    rate: null
    rateUnits: null

  fields: [
      fieldType: "hidden"
      label: "Labor class"
      name: "laborType"
      show: true
      optionsType: "laborTypeOptions"
      append: "<br />"
      fieldHelp: true
      fieldHelpValue: Choices.getHelp "dynamicDropdown"
    ,
      fieldType: "number"
      label: "Number of laborers"
      name: "laborersCount"
      show: true
    ,
      fieldType: "number"
      label: "Time per laborer"
      name: "laborTime"
      show: true
      hasSiblingField: true
    ,
      fieldType: "select"
      placeholder: "Unit"
      name: "laborTimeUnits"
      show: true
      fieldTypeSelect: true
      optionsType: "timeOptions"
    ,
      fieldType: "number"
      label: "Pay Rate"
      name: "rate"
      show: true
      hasSiblingField: true
    ,
      fieldType: "select"
      placeholder: "Unit"
      name: "rateUnits"
      show: true
      fieldTypeSelect: true
      optionsType: "timePerOptions"
  ]

  initialize: ->
    super

  calculate: ->
    type = @attributes.laborType ? ""
    quantity = @attributes.laborersCount ? 0
    time = convert.toHours @attributes.laborTime, @attributes.laborTimeUnits
    rate = convert.toPerHour @attributes.rate, @attributes.rateUnits

    @cost = time * rate * quantity

    log.trace "labor row (#{type}) ##{@cid}: #{time} hours
      x #{quantity} (laborers)  @ $#{rate}/hr = #{@cost}"

    @cost

  overview: ->
    quantity = parseFloat @attributes.laborersCount
    time = parseFloat @attributes.laborTime
    rate = parseFloat @attributes.rate

    ["No labor"] unless @numberValid quantity, time, rate

    typeKey = @attributes.laborType ? "1"
    quantity = @round quantity
    type = Choices.getLabelFor typeKey, quantity, "laborTypeOptions"

    timeKey = @attributes.laborTimeUnits ? "hour"
    time = @round time
    timeUnit = Choices.getLabelFor timeKey, time, "timeOptions"

    rateKey = @attributes.rateUnits ? "hour"
    rate = @round rate
    rateUnit = Choices.getLabelFor rateKey, 1, "timeOptions"

    ["#{quantity} #{type} for #{time} #{timeUnit} @ $#{rate}/#{rateUnit}"]
