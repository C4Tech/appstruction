# log = require "loglevel"

ChooseField = require "choices/input-choice"
ComponentFormMixin = require "mixins/component-form"
Cost = require "util/cost"
Help = require "elements/help"
MoneyField = require "forms/input-money"
NavigationActions = require "navigation/actions"
NumberField = require "forms/input-field"
RateField = require "forms/input-pay-rate"
Str = require "util/str"
Time = require "util/time"
TimeField = require "forms/input-time"

module.exports = React.createClass
  mixins: [ComponentFormMixin]

  typeName: "equipment"

  getDefaultProps: ->
    {
      item:
        type: null
        quantity: 0
        time: 0
        timeUnits: null
        price: 0
        priceUnits: "hour"
        cost: 0.0
    }

  componentDidMount: ->
    NavigationActions.setTitle <Help title="Equipment" helpText={Str.equipment} />
    NavigationActions.setNext "component", "subcontractor"
    NavigationActions.setPrev "component", "material"

    null

  recalculate: (item) ->
    time = Time.toHours item.time, item.timeUnits
    rate = Time.toPerHour item.price, item.priceUnits
    item.cost = Cost.calculate time * rate * item.quantity
    log.debug "equipment row (#{item.type}): #{item.cost}"
    log.trace "#{item.quantity} x #{time} #{item.timeUnits}
      @ $#{item.price}/#{item.priceUnits}"

    item

  render: ->
    <div>
      <ChooseField name="type"
                   label={<Help title="Equipment Type" helpText={Str.dropdown} />}
                   type="equipment"
                   className="equipment-type"
                   value={@props.item.type}
                   onChange={@handleSelect "type"} />

      <NumberField name="quantity" label="How many"
                   value={@props.item.quantity}
                   onChange={@handleChange} />

      <NumberField name="time" label="How long"
                   className="has-sibling-field"
                   value={@props.item.time}
                   onChange={@handleChange} />

      <TimeField name="time-units"
                 className="time-units"
                 value={@props.item.timeUnits}
                 onChange={@handleSelect "timeUnits"} />

      <MoneyField name="price" label="What rate"
                  className="has-sibling-field"
                  value={@props.item.price}
                  onChange={@handleChange} />

      <RateField name="price-units"
                 className="price-units"
                 value={@props.item.priceUnits}
                 onChange={@handleSelect "priceUnits"} />
    </div>
