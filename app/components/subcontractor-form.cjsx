# log = require "loglevel"

ComponentFormMixin = require "mixins/component-form"
MoneyField = require "forms/input-money"
TextField = require "forms/input-field"

module.exports = React.createClass
  mixins: [ComponentFormMixin]

  getDefaultProps: ->
    {
      item:
        scope: ""
        cost: 0.0
    }

  render: ->
    <div>
      <TextField name="scope" label="Scope of Work"
                 value={@props.item.scope}
                 onChange={@handleChange} />

      <MoneyField name="cost" label="Contractor Amount"
                  value={@props.item.cost}
                  onChange={@handleChange} />
    </div>
