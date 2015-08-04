ChoicesStore = require "choices/store"

module.exports =
  getDefaultProps: ->
    {
      item:
        type: 1
        quantity: 0
        price: 0
    }

  render: ->
    item = @props.item
    nothing = <div>No Material</div>

    return nothing unless item.price

    type = ChoicesStore.getLabelFor "material", item.type, item.quantity, true
    unit = ChoicesStore.getLabelFor "material", item.type

    <div>
      <div>Item: {type}</div>
      <div>${item.price} per #{unit}</div>
      <div>Total price: ${item.cost}</div>
    </div>
