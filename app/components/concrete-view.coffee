module.exports =
  defaultUnit: "ft"

  getInitialState: ->
    {
      id: null
      type: null
      quantity: 0
      length: 0
      lengthUnits: null
      width: 0
      widthUnits: null
      depth: 0
      depthUnit: null
      price: 0
      priceUnits: "cuft"
      tax: 0.0
    }

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
