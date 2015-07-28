# log = require "loglevel"

JobActions = require "jobs/actions"
MoneyField = require "forms/input-money"
TextField = require "forms/input-field"

FormGroup = ReactBootstrap.FormGroup

module.exports = React.createClass
  getDefaultProps: ->
    {
      data:
        scope: ""
        cost: 0.0
    }

  handleChange: (event) ->
    data = @props.data
    data[event.target.name] = event.target.value
    log.debug "subcontractor row (#{data.scope}): #{data.cost}"
    JobActions.updateComponent "subcontractor", data

    null

  render: ->
    <FormGroup>
      <TextField name="scope" label="Scope of Work"
                 value={@props.data.scope}
                 onChange={@handleChange} />

      <MoneyField name="cost" label="Contractor Amount"
                  value={@props.data.cost}
                  onChange={@handleChange} />
    </FormGroup>
