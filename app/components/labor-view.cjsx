ChoicesStore = require "choices/store"
Time = require "util/time"

module.exports =
  getDefaultProps: ->
    {
      item:
        type: 1
        quantity: 0
        time: 0
        timeUnits: null
        price: 0
        priceUnits: "hour"
    }

  render: ->
    item = @props.item
    nothing = <div>No Labor</div>

    return nothing unless item.price and item.time

    type = ChoicesStore.getLabelFor "labor", item.type, item.quantity, true
    units = Time.getLabelFor "time", item.timeUnits, item.time, true
    unit = Time.getLabelFor "time", item.priceUnits

    <div>
      <div>Item: {type}</div>
      <div>#{units}</div>
      <div>${item.price} per #{unit}</div>
      <div>Total price: ${item.cost}</div>
    </div>
