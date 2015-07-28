ChoicesStore = require "choices/store"
Time = require "util/time"

module.exports =
  getDefaultProps: ->
    {
      data:
        type: 1
        quantity: 0
        time: 0
        timeUnits: null
        rate: 0
        rateUnits: "hour"
    }

  render: ->
    data = @props.data
    nothing = <div>No Equipment</div>

    return nothing unless data.rate and data.time

    type = ChoicesStore.getLabelFor "equipment", data.type, data.quantity, true
    units = Time.getLabelFor "time", data.timeUnits, data.time, true
    unit = Time.getLabelFor "time", data.priceUnits

    <div>
      <div>Item: {type}</div>
      <div>#{units}</div>
      <div>${data.price} per #{unit}</div>
      <div>Total price: ${data.cost}</div>
    </div>
