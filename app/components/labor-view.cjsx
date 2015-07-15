ChoicesStore = require "choices/store"

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
      body = <div>No Labor</div>

      if @props.data.rate and @props.data.time
        type = ChoicesStore.getLabelFor "labor", @props.data.type, @props.data.quantity
        units = ChoicesStore.getLabelFor "time", @props.data.timeUnits, @props.data.time
        unit = ChoicesStore.getLabelFor "time", @props.data.rateUnits

        body = <div>{@props.data.quantity} {type} for {@props.data.time} {units} @ ${@props.data.rate}/{unit}</div>

      <div>
        {body}
      </div>
