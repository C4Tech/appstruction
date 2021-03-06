ChoicesStore = require "choices/store"
Time = require "util/time"

module.exports = React.createClass
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
      {type.toLowerCase()} for {units.toLowerCase()} @ ${item.price}/{unit.toLowerCase()}
    </div>
