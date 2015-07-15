ChoicesStore = require "choices/store"

module.exports =
  getDefaultProps: ->
    {
      data:
        scope: ""
        cost: 0.0
    }

    render: ->
      body = <div>No Subcontractor</div>

      if @props.data.cost
        body = <div>{@props.scope}: ${@props.cost}</div>

      <div>
        {body}
      </div>
