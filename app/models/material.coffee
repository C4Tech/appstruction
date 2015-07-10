BaseModel = require "models/base"
Choices = require "models/choices"

module.exports = class MaterialModel extends BaseModel
  defaults:
    quantity: null
    price: null
    materialType: null
    tax: null

  fields: [
      fieldType: "hidden"
      label: "Material Type"
      name: "materialType"
      show: true
      optionsType: "materialTypeOptions"
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
      name: "price"
      label: "What price"
      show: true
    ,
      fieldType: "select"
      name: "materialType"
      label: "What Type"
      show: false
    ,
      fieldType: "number"
      name: "tax"
      label: "What tax rate"
      show: true
      displayAppend: "%"
      inputGroup: true
      inputGroupAppend: true
      inputGroupValue: "%"
  ]

  initialize: ->
    super

  calculate: ->
    type = @attributes.materialType ? ""
    quantity = @attributes.quantity ? 0
    price = @attributes.price ? 0
    tax = @attributes.tax ? 0

    @cost = quantity * price
    @cost += @cost * tax/100
    log.trace "material row (#{type}) ##{@cid}: #{quantity}@#{price}
      + #{tax}% tax = #{@cost}"

    @cost

  overview: ->
    quantity = parseFloat @attributes.quantity
    price = parseFloat @attributes.price

    ["No material"] unless @numberValid quantity, price

    quantity = @round quantity
    price = @round price

    typeKey = @attributes.materialType ? "wire"
    type = Choices.getLabelFor typeKey, quantity, "materialTypeOptions"
    unit = Choices.getLabelFor typeKey, 1, "materialTypeOptions"

    ["#{quantity} #{type} @ $#{price}/#{unit}"]
