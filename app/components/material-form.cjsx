# log = require "loglevel"

ChooseField = require "choices/input-choice"
ComponentFormMixin = require "mixins/component-form"
Cost = require "util/cost"
Help = require "elements/help"
MoneyField = require "forms/input-money"
NavigationActions = require "navigation/actions"
NumberField = require "forms/input-field"
PercentField = require "forms/input-percentage"
Str = require "util/str"

FormGroup = ReactBootstrap.FormGroup

module.exports = React.createClass
  mixins: [ComponentFormMixin]

  typeName: "material"

  getDefaultProps: ->
    {
      item:
        type: null
        quantity: 0
        price: 0
        tax: 0.0
        cost: 0.0
    }

  componentDidMount: ->
    NavigationActions.setTitle <Help title="Materials" helpText={Str.material} />
    NavigationActions.setNext "component", "equipment"
    NavigationActions.setPrev "component", "labor"

    null

  recalculate: (item) ->
    item = @props.item
    item.cost = Cost.calculate item.quantity * item.price, item.tax
    log.debug "material row (#{item.type}): #{item.cost}"
    log.trace "#{item.quantity} @ $#{item.price} + #{item.tax}% tax"

    item

  render: ->
    <div>
      <ChooseField name="type"
                   label={<Help title="Material Type" helpText={Str.dropdown} />}
                   type="material"
                   className="material-type"
                   value={@props.item.type}
                   onChange={@handleSelect "type"} />

      <NumberField name="quantity" label="How many"
                 value={@props.item.quantity}
                 onChange={@handleChange} />

      <MoneyField name="price" label="What price"
                  value={@props.item.price}
                  onChange={@handleChange} />

      <PercentField name="tax" label="What tax rate"
                    value={@props.item.tax}
                    onChange={@handleChange} />
    </div>
