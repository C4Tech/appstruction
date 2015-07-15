JobActions = require "jobs/actions"
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

    JobActions.updateComponent "subcontractor", data

    null

  render: ->
    <FormGroup>
      <TextField name="scope" label="Scope of Work"
                 value={@props.data.scope}
                 onChange={@handleChange} />

      <TextField name="cost" label="Contractor Amount"
                 value={@props.data.cost}
                 onChange={@handleChange} />
    </FormGroup>
