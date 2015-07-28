# log = require "loglevel"

Cost = require "util/cost"
ChooseField = require "choices/input-choice"
JobActions = require "jobs/actions"
Measure = require "util/measure"
MeasurementField = require "forms/input-measurement"
MoneyField = require "forms/input-money"
NavigationActions = require "navigation/actions"
NumberField = require "forms/input-field"
PercentField = require "forms/input-percentage"
Str = require "util/str"
VolumeField = require "forms/input-volume"

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
        price: 0
        priceUnits: "ft"
        tax: 0.0
        cost: 0.0
    }

  componentWillMount: ->
    NavigationActions.setTitle "Concrete"
    NavigationActions.setNext "component", "labor"
    null

  componentWillUnmount: ->
    NavigationActions.unsetTitle()
    NavigationActions.unsetNext()
    null

  handleChange: (event) ->
    data = @props.data
    name = Str.dashToCamel event.target.name
    data[name] = event.target.value
    data.volume = @calculateVolume data
    data.cost = @calculateCost data
    log.debug "concrete row (#{data.type}): #{data.volume} (vol) = #{data.cost}"
    JobActions.updateComponent "concrete", data

    null

  calculateVolume: (data) ->
    Measure.setDefault data.priceUnits
    depth = Measure.normalize data.depth, data.depthUnits
    length = Measure.normalize data.length, data.lengthUnits
    width = Measure.normalize data.width, data.widthUnits
    volume = depth.mul(length).mul(width).scalar * data.quantity

    log.trace "concrete row volume (#{data.type}):
      #{depth} (d) x #{width} (w) x #{length} (h) = #{volume}"

    volume

  calculateCost: (data) ->
    cost = Cost.calculate data.quantity *  data.volume * data.price, data.tax

    log.trace "concrete row cost (#{data.type}): #{data.quantity} x
      #{data.volume} @ $#{data.price} + #{data.tax}% tax = #{cost}"

    cost

  render: ->
    <FormGroup>
      <ChooseField name="type" label="What item"
                   type="concrete"
                   value={@props.data.type}
                   onChange={@handleChange} />

      <NumberField name="quantity" label="How many"
                   value={@props.data.quantity}
                   onChange={@handleChange} />

      <NumberField name="length" label="How long"
                   value={@props.data.length}
                   onChange={@handleChange} />

      <MeasurementField name="length-units"
                        value={@props.data.lengthUnits}
                        onChange={@handleChange} />

      <NumberField name="width" label="How wide"
                   value={@props.data.width}
                   onChange={@handleChange} />

      <MeasurementField name="width-units"
                        value={@props.data.widthUnits}
                        onChange={@handleChange} />

      <NumberField name="depth" label="How deep"
                   value={@props.data.depth}
                   onChange={@handleChange} />

      <MeasurementField name="depth-units"
                        value={@props.data.depthUnits}
                        onChange={@handleChange} />

      <MoneyField name="price" label="What price"
                   value={@props.data.price}
                   onChange={@handleChange} />

      <VolumeField name="price-units"
                   value={@props.data.priceUnits}
                   onChange={@handleChange} />

      <PercentField name="tax" label="What tax rate"
                    value={@props.data.tax}
                    onChange={@handleChange} />
    </FormGroup>
