ChoicesStore = require "choices/store"
Measure = require "util/measure"

module.exports =
  getDefaultProps: ->
    {
      data:
        type: 1
        quantity: 0
        volume: 0
        price: 0
        priceUnits: "ft"
        cost: 0.0
    }

  render: ->
    data = @props.data
    nothing = <div>No Concrete</div>

    return nothing unless data.price and data.volume

    type = ChoicesStore.getLabelFor "concrete", data.type, data.quantity, true
    units = Measure.getLabelFor "volume", data.priceUnits, data.volume, true
    unit = Measure.getLabelFor "volume", data.priceUnits

    <div>
      <div>Item: {type}</div>
      <div>#{units} of concrete</div>
      <div>${data.price} per #{unit}</div>
      <div>Total price: ${data.cost}</div>
    </div>
