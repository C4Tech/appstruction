ChoicesStore = require "choices/store"

module.exports =
  getDefaultProps: ->
    {
      data:
        type: 1
        quantity: 0
        volume: 0
        rate: 0
        rateUnits: "ft"
        cost: 0.0
    }

    render: ->
      body = <div>No Concrete</div>

      if @props.data.rate and @props.data.volume
        type = ChoicesStore.getLabelFor "concrete", @props.data.type, @props.data.quantity
        body = <div>Items: {@props.data.quantity} {type}</div>

        units = ChoicesStore.getLabelFor "measurement", @props.data.rateUnits, @props.data.volume
        body += <div>{@props.data.volume} #{units} of concrete</div>

        unit = ChoicesStore.getLabelFor "measurement", @props.data.rateUnits
        body += <div>${@props.data.rate} per #{unit}</div>

        body += <div>Total price: ${@props.data.cost}</div>

      <div>
        {body}
      </div>
