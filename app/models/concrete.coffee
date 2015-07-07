BaseModel = require "models/base"
Choices = require "models/choices"
# Qty = require "js-quantities"

module.exports = class ConcreteModel extends BaseModel
  defaults:
    type: null
    quantity: null
    depth: null
    depthUnits: null
    width: null
    widthUnits: null
    length: null
    lengthUnits: null
    price: null
    priceUnits: null
    tax: null

  volume: 0

  fields: [
      fieldType: "hidden"
      label: "What item"
      name: "type"
      show: true
      optionsType: "typeOptions"
      append: "<br />"
      fieldHelp: true
      fieldHelpValue: Choices.getHelp "dynamicDropdown"
    ,
      fieldType: "number"
      name: "quantity"
      label: "How many"
      show: true
    ,
      fieldType: "number"
      name: "length"
      label: "How long"
      show: true
      displayBegin: true
      hasSiblingField: true
    ,
      fieldType: "select"
      placeholder: "Unit"
      name: "lengthUnits"
      show: true
      fieldTypeSelect: true
      optionsType: "measurementOptions"
      displayEnd: true
    ,
      fieldType: "number"
      label: "How wide"
      name: "width"
      show: true
      displayBegin: true
      hasSiblingField: true
    ,
      fieldType: "select"
      placeholder: "Unit"
      name: "widthUnits"
      show: true
      fieldTypeSelect: true
      optionsType: "measurementOptions"
      displayEnd: true
    ,
      fieldType: "number"
      label: "How deep"
      name: "depth"
      show: true
      displayBegin: true
      hasSiblingField: true
    ,
      fieldType: "select"
      placeholder: "Unit"
      name: "depthUnits"
      show: true
      fieldTypeSelect: true
      optionsType: "measurementOptions"
      displayEnd: true
    ,
      fieldType: "number"
      label: "What price"
      name: "price"
      show: true
      displayBegin: true
      displayPrepend: "$"
      hasSiblingField: true
    ,
      fieldType: "select"
      placeholder: "Unit"
      name: "priceUnits"
      show: true
      fieldTypeSelect: true
      optionsType: "priceOptions"
      displayEnd: true
    ,
      fieldType: "number"
      label: "What tax rate"
      name: "tax"
      show: true
      displayAppend: "%"
      inputGroup: true
      inputGroupAppend: true
      inputGroupValue: "%"
  ]

  initialize: ->
    super

  calculate: ->
    depthUnits = @attributes.depthUnits or "ft"
    depthValue = @attributes.depth or 0
    depth = Qty(depthValue + " " + depthUnits).to priceUnits

    lengthUnits = @attributes.lengthUnits or "ft"
    lengthValue = @attributes.length or 0
    length = Qty(lengthValue + " " + lengthUnits).to priceUnits

    widthUnits = @attributes.widthUnits or "ft"
    widthValue = @attributes.width or 0
    width = Qty(widthValue + " " + widthUnits).to priceUnits

    @volume = depth.mul(length).mul(width).scalar
    quantity = @attributes.quantity or 0
    @volume = @volume * quantity

    priceUnits = @attributes.priceUnits or "ft"
    priceValue = @attributes.price or 0
    @cost = @volume * priceValue

    taxUnits = @attributes.tax or 0
    taxValue = taxUnits / 100
    tax = @cost * taxValue

    @cost += tax
    type = @attributes.concreteType or ""
    console.log "concrete row (#{type}) ##{@cid}:
      #{depth} (d) * #{width} (w) x #{length} (h) x #{quantity}
      @ $#{priceValue} + #{taxUnits} tax = #{@cost}"

    @cost

  overview: ->
    noConcrete = ["No concrete"]
    priceValue = parseFloat @attributes.price or 0
    noConcrete if isNaN(priceValue) or priceValue is 0

    priceOptionsDisplay = Choices.get "priceOptionsDisplay"
    priceUnitsKey = @attributes.priceUnits or "ft"

    noConcrete if isNaN(@volume) or @volume is 0
    volumeNoun = "plural"
    volumeNoun = "singular"  if @volume is 1
    volumeUnits = priceOptionsDisplay[volumeNoun][priceUnitsKey]
    volumeRounded = Math.round(@volume * 100) / 100
    volume = "#{volumeRounded} #{volumeUnits} of concrete"

    quantity = @attributes.quantity or 0

    typeNoun = "plural"
    typeNoun = "singular" if quantity is 1
    typeKey = @attributes.type or "1"
    typeDisplay = Choices.get "typeOptionsDisplay"
    type = typeDisplay[typeNoun][typeKey]
    type = Choices.getTextById "typeOptions", typeKey unless type?
    type = type.toLowerCase()

    priceUnits = priceOptionsDisplay.singular[priceUnitsKey]
    concrete = "Items: #{quantity} #{type}"
    price = "$#{priceValue.toFixed(2)} per #{priceUnits}"
    total = "Total price: $#{@cost.toFixed(2)}"

    [concrete, volume, price, total]
