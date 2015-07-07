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
    type = @attributes.laborType or ""
    time = convert.toHours @attributes.laborTime, @attributes.laborTimeUnits
    rate = convert.toPerHour @attributes.rate, @attributes.rateUnits
    quantity = @attributes.laborersCount or 0

    @cost = time * rate * quantity
    console.log "labor row (#{type}) ##{@cid}: #{time} hours
      x #{quantity} (laborers)  @ $#{rate}/hr = #{@cost}"

    @cost

  overview: ->
    no_labor = ["No labor"]
    laborType_display = Choices.get "laborTypeOptions_display"
    timeOptions_display = Choices.get "timeOptions_display"

    laborType_key = @attributes.laborType or "1"
    laborTime_key = @attributes.laborTimeUnits or "hour"
    rate_key = @attributes.rateUnits or "hour"

    laborersCount = parseFloat(@attributes.laborersCount) or 0
    laborTime = parseFloat(@attributes.laborTime) or 0
    rate = parseFloat(@attributes.rate) or 0

    if isNaN(laborersCount) or laborersCount == 0
      return no_labor
    else if isNaN(laborTime) or laborTime == 0
      return no_labor
    else if isNaN(rate) or rate == 0
      return no_labor

    # round values to no more than 2 decimals
    laborersCount = Math.round(laborersCount * 100) / 100
    laborTime = Math.round(laborTime * 100) / 100
    rate = Math.round(rate * 100) / 100

    nounType = "singular"
    if laborersCount > 1
      nounType = "plural"
    laborType = laborType_display[nounType][laborType_key]
    unless laborType?
      laborType = Choices.getTextById("laborTypeOptions", laborType_key).toLowerCase()

    nounType = "singular"
    if laborTime > 1
      nounType = "plural"
    laborTimeUnit = timeOptions_display[nounType][laborTime_key]

    rateUnit = timeOptions_display["singular"][rate_key]

    laborer_item = "#{laborersCount} #{laborType} for #{laborTime} #{laborTimeUnit} @ $#{rate}/#{rateUnit}"

    return [
      laborer_item,
    ]
