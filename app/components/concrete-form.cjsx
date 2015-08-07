# log = require "loglevel"

Cost = require "util/cost"
ChooseField = require "choices/input-choice"
ComponentFormMixin = require "mixins/component-form"
Help = require "elements/help"
Measure = require "util/measure"
MeasurementField = require "forms/input-measurement"
MoneyField = require "forms/input-money"
NavigationActions = require "navigation/actions"
NumberField = require "forms/input-field"
PercentField = require "forms/input-percentage"
VolumeField = require "forms/input-volume"

module.exports = React.createClass
  mixins: [ComponentFormMixin]

  typeName: "concrete"

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

  componentDidMount: ->
    NavigationActions.setTitle "Concrete"
    NavigationActions.setNext "component", "labor"
    NavigationActions.setPrev "add"

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
    volume = depth.mul(length).mul(width).scalar.toFixed(2)/1
    volume = 0.0 if isNaN volume

    log.trace "#{depth} (d) x #{width} (w) x #{length} (h) = #{volume}"

    volume

  calculateCost: (item) ->
    price = item.quantity * item.volume * item.price
    price = 0.00 if isNaN price
    tax = if isNaN item.tax then 0.0 else item.tax
    cost = Cost.calculate price, tax

    log.trace "#{item.quantity} x #{item.volume} @ $#{item.price} + #{tax}% tax = #{price}"

    cost

  render: ->
    <div>
      <ChooseField name="type"
                  label={<Help title="What item" helpText="Dropdown Help" />}
                   type="concrete"
                   value={@props.item.type}
                   onChange={@handleSelect "type"} />

      <NumberField name="quantity" label="How many"
                   value={@props.item.quantity}
                   onChange={@handleChange} />

      <NumberField name="length" label="How long"
                   className="has-sibling-field"
                   value={@props.item.length}
                   onChange={@handleChange} />

      <MeasurementField name="length-units"
                        value={@props.item.lengthUnits}
                        onChange={@handleSelect "lengthUnits"} />

      <NumberField name="width" label="How wide"
                   className="has-sibling-field"
                   value={@props.item.width}
                   onChange={@handleChange} />

      <MeasurementField name="width-units"
                        value={@props.item.widthUnits}
                        onChange={@handleSelect  "widthUnits"} />

      <NumberField name="depth" label="How deep"
                   className="has-sibling-field"
                   value={@props.item.depth}
                   onChange={@handleChange} />

      <MeasurementField name="depth-units"
                        value={@props.item.depthUnits}
                        onChange={@handleSelect  "depthUnits"} />

      <MoneyField name="price" label="What price"
                   className="has-sibling-field"
                   value={@props.item.price}
                   onChange={@handleChange} />

      <VolumeField name="price-units"
                   value={@props.item.priceUnits}
                   onChange={@handleSelect  "priceUnits"} />

      <PercentField name="tax" label="What tax rate"
                    value={@props.item.tax}
                    onChange={@handleChange} />
    </div>
