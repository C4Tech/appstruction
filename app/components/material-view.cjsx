ChoicesStore = require "choices/store"

module.exports =
  getDefaultProps: ->
    {
      data:
        type: 1
        quantity: 0
        price: 0
    }

  render: ->
    data = @props.data
    nothing = <div>No Material</div>

    return nothing unless data.price

    type = ChoicesStore.getLabelFor "material", data.type, data.quantity, true
    unit = ChoicesStore.getLabelFor "material", data.type

    <div>
      <div>Item: {type}</div>
      <div>${data.price} per #{unit}</div>
      <div>Total price: ${data.cost}</div>
    </div>
