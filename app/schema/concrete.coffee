module.exports =
  defaultUnit: "ft"

  fields: [
      fieldType: "hidden"
      label: "What item"
      name: "type"
      show: true
      optionsType: "concreteTypeOptions"
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

  calculate: (attributes, index) ->
    priceUnits = attributes.priceUnits ? @defaultUnit
    type = attributes.type ? ""
    depth = @normalize attributes.depth, attributes.depthUnits, priceUnits
    length = @normalize attributes.length, attributes.lengthUnits, priceUnits
    width = @normalize attributes.width, attributes.widthUnits, priceUnits

    volume = @calculateVolume depth, length, width, attributes.quantity
    cost = @calculatePrice volume, attributes.price, attributes.tax

    log.debug "concrete row (#{type}) ##{index}:
      #{depth} (d) * #{width} (w) x #{length} (h) x #{attributes.quantity}
      @ $#{attributes.price} + #{attributes.tax}% tax = #{cost}"

    cost

  normalize: (measure = 0, unit = @defaultUnit, toUnit = @defaultUnit) ->
    Qty("#{measure} #{unit}").to toUnit

  setVolume: (depth, length, width, quantity = 0) ->
    volume = depth.mul(length).mul(width).scalar
    @round volume * quantity

  setPrice: (volume, price = 0, tax = 0) ->
    cost = volume * price
    tax /= 100
    cost += cost * tax
    cost.toFixed 2

  overview: ->
    value = parseFloat attributes.price ? 0
    ["No concrete"] unless @numberValid value, @volume

    key = attributes.type ? "1"
    type = Choices.getLabelFor key, quantity, "concreteTypeOptions"
    quantity = attributes.quantity ? 0

    priceUnits = attributes.priceUnits ? @defaultUnit
    units = Choices.getLabelFor priceUnits, @volume, "priceOptions"
    unit = Choices.getLabelFor priceUnits, 1, "priceOptions"

    [
      "Items: #{quantity} #{type}"
      "#{volume} #{units} of concrete"
      "$#{value.toFixed(2)} per #{unit}"
      "Total price: $#{cost}"
    ]
