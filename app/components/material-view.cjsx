ChoicesStore = require "choices/store"

module.exports = React.createClass
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
      {type.toLowerCase()} @ ${item.price}/{unit.toLowerCase()}
    </div>
