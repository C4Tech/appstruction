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
      body = <div>No Material</div>

      if @props.data.price
        type = ChoicesStore.getLabelFor "material", @props.data.type, @props.data.quantity
        unit = ChoicesStore.getLabelFor "material", @props.data.type

        body = <div>{@props.data.quantity} {type} @ ${@props.data.price}/{unit}</div>

      <div>
        {body}
      </div>
