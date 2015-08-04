module.exports =
  getDefaultProps: ->
    {
      item:
        scope: ""
        cost: 0.0
    }

  render: ->
    item = @props.item
    nothing = <div>No Subcontractor</div>

    return nothing unless item.cost

    <div>
      <div>{item.scope}</div>
      <div>Total price: ${item.cost}</div>
    </div>
