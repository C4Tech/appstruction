ChoicesStore = require "choices/store"
Measure = require "util/measure"

module.exports = React.createClass
  getDefaultProps: ->
    {
      item:
        type: null
        quantity: 0
        volume: 0
        price: 0
        priceUnits: "ft"
        cost: 0.0
    }

  render: ->
    item = @props.item
    nothing = <div>No Concrete</div>

    return nothing unless item.cost and item.volume

    type = ChoicesStore.getLabelFor "concrete", item.type, item.quantity, true
    units = Measure.getLabelFor "volume", item.priceUnits, item.volume, true
    unit = Measure.getLabelFor "volume", item.priceUnits

    <div>
      {type.toLowerCase()} ({units.toLowerCase()} of concrete) @ ${item.price}/{unit.toLowerCase()}
    </div>
