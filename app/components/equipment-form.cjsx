# log = require "loglevel"

ChooseField = require "choices/input-choice"
ComponentFormMixin = require "mixins/component-form"
Cost = require "util/cost"
MoneyField = require "forms/input-money"
NumberField = require "forms/input-field"
RateField = require "forms/input-pay-rate"
Time = require "util/time"
TimeField = require "forms/input-time"

module.exports = React.createClass
  mixins: [ComponentFormMixin]

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
      <ChooseField name="type" label="Equipment Type"
                   type="equipment"
                   value={@props.item.type}
                   onChange={@handleSelect} />

      <NumberField name="quantity" label="How many"
                   value={@props.item.quantity}
                   onChange={@handleChange} />

      <NumberField name="time" label="How long"
                   value={@props.item.time}
                   onChange={@handleChange} />

      <TimeField name="time-units"
                 value={@props.item.timeUnits}
                 onChange={@handleSelect} />

      <MoneyField name="price" label="What rate"
                  value={@props.item.price}
                  onChange={@handleChange} />

      <RateField name="price-units"
                 value={@props.item.priceUnits}
                 onChange={@handleSelect} />
    </div>
