module.exports =
  getDefaultProps: ->
    {
      data:
        scope: ""
        cost: 0.0
    }

  render: ->
    data = @props.data
    nothing = <div>No Subcontractor</div>

    return nothing unless data.cost

    <div>
      <div>{data.scope}</div>
      <div>Total price: ${data.cost}</div>
    </div>
