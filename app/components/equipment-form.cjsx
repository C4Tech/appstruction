Str = require "util/str"
Time = require "util/time"
JobActions = require "jobs/actions"
ChooseField = require "choices/input-choice"
TextField = require "forms/input-field"
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
        rate: 0
        rateUnits: "hour"
        cost: 0.0
    }

  handleChange: (event) ->
    data = @props.data

    name = Str.dashToCamel event.target.name
    data[name] = event.target.value

    data.cost = @calculate data

    JobActions.updateComponent "equipment", data

    null

  calculate: (data) ->
    time = Time.toHours data.time, data.timeUnits
    rate = Time.toPerHour data.rate, data.rateUnits

    cost = time * rate * data.quantity

    log.trace "equipment row (#{data.type}):
      #{time} (#{data.timeUnits}) x #{data.quantity} (quantity)
      @ $#{rate} (#{data.rateUnits}) = #{cost}"

    cost

  render: ->
    <FormGroup>
      <ChooseField type="equipment" label="Equipment Type"
                    value={@props.data.type}
                    onChange={@handleChange} />

      <TextField name="quantity" label="How many"
                 value={@props.data.quantity}
                 onChange={@handleChange} />

      <TextField name="time" label="How long"
                 value={@props.data.rate}
                 onChange={@handleChange} />

      <TimeField name="time-units"
                 value={@props.data.timeUnits}
                 onChange={@handleChange} />

      <TextField name="rate" label="What rate"
                 value={@props.data.rate}
                 onChange={@handleChange} />

      <TimeField name="rate-units"
                 value={@props.data.rateUnits}
                 onChange={@handleChange} />
    </FormGroup>
