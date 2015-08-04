# log = require "loglevel"

ComponentFormMixin = require "mixins/component-form"
Cost = require "util/cost"
MoneyField = require "forms/input-money"
NavigationActions = require "navigation/actions"
TextField = require "forms/input-field"

module.exports = React.createClass
  mixins: [ComponentFormMixin]

  typeName: "subcontractor"

  getDefaultProps: ->
    {
      item:
        scope: ""
        cost: 0.0
    }

  componentWillMount: ->
    NavigationActions.setTitle "Subcontractor"
    NavigationActions.setNext "save"
    NavigationActions.setPrev "component", "material"
    null

  recalculate: (item) ->
    item = @props.item
    item.cost = Cost.calculate item.cost
    log.debug "subcontractor row (#{item.scope}): #{item.cost}"

    item

  render: ->
    <div>
      <TextField name="scope" label="Scope of Work"
                 value={@props.item.scope}
                 onChange={@handleChange} />

      <MoneyField name="cost" label="Contractor Amount"
                  value={@props.item.cost}
                  onChange={@handleChange} />
    </div>
