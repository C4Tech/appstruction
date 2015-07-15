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
      cost: 0.0
    }

  handleChange: (event) ->
    # set new state
    # calculate new cost
    # update Store if type, length, width, and depth
    null

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
