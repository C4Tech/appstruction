Str = require "util/str"
Measure = require "util/measure"
JobActions = require "jobs/actions"
ChooseField = require "choices/input-choice"
TextField = require "forms/input-field"
MeasurementField = require "forms/input-measurement"
NavigationActions = require "navigation/actions"

FormGroup = ReactBootstrap.FormGroup

module.exports = React.createClass
  getDefaultProps: ->
    {
      data:
        type: null
        quantity: 0
        length: 0
        lengthUnits: null
        width: 0
        widthUnits: null
        depth: 0
        depthUnits: null
        volume: 0
        rate: 0
        rateUnits: "ft"
        tax: 0.0
        cost: 0.0
    }

  componentWillMount: ->
    NavigationActions.setTitle "Concrete"
    NavigationActions.setNext "component", "labor"
    null

  componentWillUnmount: ->
    NavigationActions.setTitle null
    null


  handleChange: (event) ->
    data = @props.data

    name = Str.dashToCamel event.target.name
    data[name] = event.target.value

    data.volume = @calculateVolume data
    data.cost = @calculateCost data

    JobActions.updateComponent "concrete", data

    null

  calculateVolume: (data) ->
    depth = Measure.normalize data.depth, data.depthUnits, data.rateUnits
    length = Measure.normalize data.length, data.lengthUnits, data.rateUnits
    width = Measure.normalize data.width, data.widthUnits, data.rateUnits
    volume = depth.mul(length).mul(width).scalar * data.quantity

    log.debug "concrete row (#{data.type}):
      #{depth} (d) * #{width} (w) x #{length} (h) = #{volume}"

    volume

  calculateCost: (data) ->
    cost = data.volume * data.rate
    tax = data.tax / 100
    cost += cost * tax
    cost.toFixed 2

    log.debug "concrete row (#{data.type}):
      #{data.volume} x #{data.quantity} @ $#{data.rate} + #{data.tax}% tax
      = #{cost}"

    cost

  render: ->
    <FormGroup>
      <ChooseField type="concrete" label="What item"
                    value={@props.data.type}
                    onChange={@handleChange} />

      <TextField name="quantity" label="How many"
                 value={@props.data.quantity}
                 onChange={@handleChange} />

      <TextField name="length" label="How long"
                 value={@props.data.length}
                 onChange={@handleChange} />

      <MeasurementField name="length-units"
                 value={@props.data.lengthUnits}
                 onChange={@handleChange} />

      <TextField name="width" label="How wide"
                 value={@props.data.width}
                 onChange={@handleChange} />

      <MeasurementField name="width-units"
                 value={@props.data.widthUnits}
                 onChange={@handleChange} />

      <TextField name="depth" label="How deep"
                 value={@props.data.depth}
                 onChange={@handleChange} />

      <MeasurementField name="depth-units"
                 value={@props.data.depthUnits}
                 onChange={@handleChange} />

      <TextField name="rate" label="What price"
                 value={@props.data.rate}
                 onChange={@handleChange} />

      <MeasurementField name="rate-units"
                 value={@props.data.rateUnits}
                 onChange={@handleChange} />

      <TextField name="tax" label="What tax rate"
                 value={@props.data.tax} addonAfter="%"
                 onChange={@handleChange} />
    </FormGroup>
