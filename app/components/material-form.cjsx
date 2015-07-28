# log = require "loglevel"

ChooseField = require "choices/input-choice"
Cost = require "util/cost"
JobActions = require "jobs/actions"
MoneyField = require "forms/input-money"
NumberField = require "forms/input-field"
PercentField = require "forms/input-percentage"

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
    log.debug "material row (#{data.type}): #{data.cost}"
    JobActions.updateComponent "material", data

    null

  calculate: (data) ->
    cost = Cost.calculate data.quantity * data.price, data.tax
    log.trace "material row (#{data.type}): #{data.quantity}
      @ $#{data.price} + #{data.tax}% tax = #{cost}"

    cost

  render: ->
    <FormGroup>
      <ChooseField name="type" label="Material Type"
                   type="material"
                   value={@props.data.type}
                   onChange={@handleChange} />

      <NumberField name="quantity" label="How many"
                 value={@props.data.quantity}
                 onChange={@handleChange} />

      <MoneyField name="price" label="What price"
                  value={@props.data.price}
                  onChange={@handleChange} />

      <PercentField name="tax" label="What tax rate"
                    value={@props.data.tax}
                    onChange={@handleChange} />
    </FormGroup>
