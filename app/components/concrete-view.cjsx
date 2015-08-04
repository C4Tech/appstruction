ChoicesStore = require "choices/store"
Measure = require "util/measure"

module.exports =
  getDefaultProps: ->
    {
      item:
        type: 1
        quantity: 0
        volume: 0
        price: 0
        priceUnits: "ft"
        cost: 0.0
    }

  render: ->
    item = @props.item
    nothing = <div>No Concrete</div>

    return nothing unless item.price and item.volume

    type = ChoicesStore.getLabelFor "concrete", item.type, item.quantity, true
    units = Measure.getLabelFor "volume", item.priceUnits, item.volume, true
    unit = Measure.getLabelFor "volume", item.priceUnits

    <div>
      <div>Item: {type}</div>
      <div>#{units} of concrete</div>
      <div>${item.price} per #{unit}</div>
      <div>Total price: ${item.cost}</div>
    </div>
