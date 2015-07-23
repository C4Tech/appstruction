Button = ReactBootstrap.Button
Col = ReactBootstrap.Col
Input = ReactBootstrap.Input
Navigation = ReactRouter.Navigation
Row = ReactBootstrap.Row

FormInstanceMixin = require "mixins/form-instance"
Form = require "forms/base"
ChooseInput = require "choices/input-choice"
JobActions = require "jobs/actions"
NavigationActions = require "navigation/actions"

module.exports = React.createClass
  mixins: [FormInstanceMixin, Navigation]

  getInitialState: ->
    {
      form:
        group: null
        name: ""
        type: null
    }

  componentWillMount: ->
    NavigationActions.setTitle "Job Builder"
    NavigationActions.setNext "component", "concrete"
    null

  getFormData: ->
    @state.form

  changeFormField: (key, value) ->
    form = @state.form
    form[key] = value
    @setState form: form

  handleChange: (event) ->
    event.preventDefault()
    @changeFormField event.target.name, event.target.value

  handleSelect: (field) ->
    (value) =>
      @changeFormField field, value

  performSubmit: (formData) ->
    JobActions.create formData
    @transitionTo "component", {component: "concrete"}

  validate: (data) ->
    errors =
      group: []
      name: []
      type: []

    requiredText = "This field is required"

    errors.group.push requiredText unless data.group
    errors.name.push requiredText unless data.name
    errors.type.push requiredText unless data.type

    errors

  render: ->
    <Form saveLabel={null}
          handleNext={@onHandleSubmit}
          {...@props}>
      <Row>
        <ChooseInput type="group"
                     value={@state.form.group}
                     className="form-group"
                     bsStyle={@getFieldStyle "group"}
                     help={@getFieldErrors "group"}
                     onChange={@handleSelect "group"} />
      </Row>
      <Row>
        <Input type="text"
               name="name"
               placeholder="Job Name"
               value={@state.form.name}
               bsStyle={@getFieldStyle "name"}
               help={@getFieldErrors "name"}
               onChange={@handleChange} />
      </Row>
      <Row>
        <ChooseInput type="job" name="type"
                     value={@state.form.type}
                     className="form-group"
                     bsStyle={@getFieldStyle "type"}
                     help={@getFieldErrors "type"}
                     onChange={@handleSelect "type"} />
      </Row>
    </Form>
