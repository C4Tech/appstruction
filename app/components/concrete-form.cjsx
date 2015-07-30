# log = require "loglevel"

Cost = require "util/cost"
ChooseField = require "choices/input-choice"
ComponentFormMixin = require "mixins/component-form"
Measure = require "util/measure"
MeasurementField = require "forms/input-measurement"
MoneyField = require "forms/input-money"
NavigationActions = require "navigation/actions"
NumberField = require "forms/input-field"
PercentField = require "forms/input-percentage"
VolumeField = require "forms/input-volume"

module.exports = React.createClass
  mixins: [ComponentFormMixin]

  getDefaultProps: ->
    {
      item:
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

  recalculate: (item) ->
    item.volume = @calculateVolume item
    item.cost = @calculateCost item
    log.debug "concrete row (#{item.type}): #{item.volume} (vol) = #{item.cost}"

    item

  calculateVolume: (item) ->
    Measure.setDefault item.priceUnits
    depth = Measure.normalize item.depth, item.depthUnits
    length = Measure.normalize item.length, item.lengthUnits
    width = Measure.normalize item.width, item.widthUnits
    volume = depth.mul(length).mul(width).scalar * item.quantity

    log.trace "#{depth} (d) x #{width} (w) x #{length} (h) = #{volume}"

    volume

  calculateCost: (item) ->
    cost = Cost.calculate item.quantity *  item.volume * item.price, item.tax

    log.trace "#{item.quantity} x #{item.volume} @ $#{item.price} + #{item.tax}% tax"

    cost

  render: ->
    <div>
      <ChooseField name="type" label="What item"
                   type="concrete"
                   value={@props.item.type}
                   onChange={@handleSelect} />

      <NumberField name="quantity" label="How many"
                   value={@props.item.quantity}
                   onChange={@handleChange} />

      <NumberField name="length" label="How long"
                   value={@props.item.length}
                   onChange={@handleChange} />

      <MeasurementField name="length-units"
                        value={@props.item.lengthUnits}
                        onChange={@handleChange} />

      <NumberField name="width" label="How wide"
                   value={@props.item.width}
                   onChange={@handleChange} />

      <MeasurementField name="width-units"
                        value={@props.item.widthUnits}
                        onChange={@handleChange} />

      <NumberField name="depth" label="How deep"
                   value={@props.item.depth}
                   onChange={@handleChange} />

      <MeasurementField name="depth-units"
                        value={@props.item.depthUnits}
                        onChange={@handleChange} />

      <MoneyField name="price" label="What price"
                   value={@props.item.price}
                   onChange={@handleChange} />

      <VolumeField name="price-units"
                   value={@props.item.priceUnits}
                   onChange={@handleChange} />

      <PercentField name="tax" label="What tax rate"
                    value={@props.item.tax}
                    onChange={@handleChange} />
    </div>
