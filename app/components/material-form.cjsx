JobActions = require "jobs/actions"
ChooseField = require "choices/input-choice"
TextField = require "forms/input-field"

FormGroup = ReactBootstrap.FormGroup

module.exports = React.createClass
  getDefaultProps: ->
    {
      data:
        type: null
        quantity: 0
        price: 0
        tax: 0.0
        cost: 0.0
    }

  handleChange: (event) ->
    data = @props.data
    data[event.target.name] = event.target.value
    data.cost = @calculate data

    JobActions.updateComponent "material", data

    null

  calculate: (data) ->
    cost = data.quantity * data.price
    tax = data.tax / 100
    cost += cost * tax

    log.trace "material row (#{data.type}):
      #{data.quantity} (quantity) @ $#{data.price}
      + #{data.tax}% tax = #{cost}"

    cost

  render: ->
    <FormGroup>
      <ChooseField type="material" label="Material Type"
                    value={@props.data.type}
                    onChange={@handleChange} />

      <TextField name="quantity" label="How many"
                 value={@props.data.quantity}
                 onChange={@handleChange} />

      <TextField name="rate" label="What price"
                 value={@props.data.rate}
                 onChange={@handleChange} />

      <TextField name="tax" label="What tax rate"
                 value={@props.data.tax} addonAfter="%"
                 onChange={@handleChange} />
    </FormGroup>
