# log = require "loglevel"

ChooseField = require "choices/input-choice"
Cost = require "util/cost"
JobActions = require "jobs/actions"
MoneyField = require "forms/input-money"
NumberField = require "forms/input-field"
RateField = require "forms/input-pay-rate"
Str = require "util/str"
Time = require "util/time"
TimeField = require "forms/input-time"

FormGroup = ReactBootstrap.FormGroup

module.exports = React.createClass
  getDefaultProps: ->
    {
      data:
        type: null
        quantity: 0
        time: 0
        timeUnits: null
        price: 0
        priceUnits: "hour"
        cost: 0.0
    }

  handleChange: (event) ->
    data = @props.data
    name = Str.dashToCamel event.target.name
    data[name] = event.target.value
    data.cost = @calculate data
    log.debug "equipment row (#{data.type}): #{data.cost}"
    JobActions.updateComponent "equipment", data

    null

  calculate: (data) ->
    time = Time.toHours data.time, data.timeUnits
    rate = Time.toPerHour data.price, data.priceUnits
    cost = Cost.calculate time * rate * data.quantity
    log.trace "equipment row (#{data.type}): #{data.quantity} x
      #{time} #{data.timeUnits} @ $#{data.price}/#{data.priceUnits} = #{cost}"

    cost

  render: ->
    <FormGroup>
      <ChooseField name="type" label="Equipment Type"
                   type="equipment"
                   value={@props.data.type}
                   onChange={@handleChange} />

      <NumberField name="quantity" label="How many"
                   value={@props.data.quantity}
                   onChange={@handleChange} />

      <NumberField name="time" label="How long"
                   value={@props.data.time}
                   onChange={@handleChange} />

      <TimeField name="time-units"
                 value={@props.data.timeUnits}
                 onChange={@handleChange} />

      <MoneyField name="price" label="What rate"
                  value={@props.data.price}
                  onChange={@handleChange} />

      <RateField name="price-units"
                 value={@props.data.priceUnits}
                 onChange={@handleChange} />
    </FormGroup>
