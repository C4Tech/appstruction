BaseModel = require "models/base"
Choices = require "models/choices"
convert = require "models/convert"

module.exports = class EquipmentModel extends BaseModel
  defaults:
    equipmentTime: null
    equipmentType: null
    quantity: null
    rate: null
    rateUnits: null

  fields: [
      fieldType: "hidden"
      label: "Equipment Type"
      name: "equipmentType"
      show: true
      optionsType: "equipmentTypeOptions"
      append: "<br />"
      fieldHelp: true
      fieldHelpValue: Choices.getHelp "dynamicDropdown"
    ,
      fieldType: "number"
      label: "How many"
      name: "quantity"
      show: true
    ,
      fieldType: "number"
      label: "How long"
      name: "equipmentTime"
      show: true
    ,
      fieldType: "number"
      label: "What rate"
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
    equipmentType = @attributes.equipmentType or ""

    time = convert.toHours @attributes.equipmentTime, @attributes.rateUnits
    rate = convert.toPerHour @attributes.rate, @attributes.rateUnits
    quantity = @attributes.quantity or 0
    @cost = time * rate * quantity

    console.log "equipment row (#{equipmentType}) ##{@cid}:
      #{time} (#{@attributes.rateUnits}) x #{quantity} (quantity)
      @ $#{rate} (#{@attributes.rateUnits}) = #{@cost}"

    @cost

  overview: ->
    noEquipment = ["No equipment"]

    quantity = parseFloat @attributes.quantity or 0
    noEquipment if isNaN(quantity) or quantity is 0
    quantity = Math.round(quantity * 100) / 100

    time = parseFloat @attributes.equipmentTime or 0
    noEquipment if isNaN(time) or time is 0
    time = Math.round(time * 100) / 100

    rate = parseFloat(@attributes.rate) or 0
    noEquipment if isNaN(rate) or rate is 0

    typeNoun = "plural"
    typeNoun = "singular" if quantity is 1
    typeDisplay = Choices.get "equipmentTypeOptionsDisplay"
    typeKey = @attributes.equipmentType or "dump truck"
    type = typeDisplay[typeNoun][typeKey]
    type = Choices.getTextById "equipmentTypeOptions", typeKey unless type?
    type = type.toLowerCase()

    rateKey = @attributes.rateUnits or "hour"

    timeNoun = "plural"
    timeNoun = "singular" if time is 1
    timeOptionsDisplay = Choices.get "timeOptionsDisplay"
    timeUnit = timeOptionsDisplay[timeNoun][rateKey]

    rateUnit = timeOptionsDisplay["singular"][rateKey]

    ["#{quantity} #{type} for #{time} #{timeUnit} @ $#{rate}/#{rateUnit}"]
