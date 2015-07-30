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
    item = @props.item
    time = Time.toHours item.time, item.timeUnits
    rate = Time.toPerHour item.price, item.priceUnits
    item.cost = Cost.calculate time * rate * item.quantity
    log.debug "labor row (#{item.type}): #{item.cost}"
    log.trace "#{item.quantity} x #{time} #{item.timeUnits}
      @ $#{price}/#{item.priceUnits}"

    item

  render: ->
    <div>
      <ChooseField name="type" label="Labor Class"
                   type="labor"
                   value={@props.item.type}
                   onChange={@handleChange} />

      <NumberField name="quantity" label="Number of laborers"
                   value={@props.item.quantity}
                   onChange={@handleChange} />

      <NumberField name="time" label="Time per laborer"
                   value={@props.item.time}
                   onChange={@handleChange} />

      <TimeField name="time-units"
                 value={@props.item.timeUnits}
                 onChange={@handleChange} />

      <MoneyField name="price" label="Pay rate"
                  value={@props.item.price}
                  onChange={@handleChange} />

      <RateField name="price-units"
                 value={@props.item.priceUnits}
                 onChange={@handleChange} />
    </div>
