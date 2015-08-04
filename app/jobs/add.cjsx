Col = ReactBootstrap.Col
Navigation = ReactRouter.Navigation
Row = ReactBootstrap.Row

ChooseInput = require "choices/input-choice"
Form = require "forms/base"
FormInstanceMixin = require "mixins/form-instance"
InputField = require "forms/input-field"
JobActions = require "jobs/actions"
JobStore = require "jobs/store"
NavigationActions = require "navigation/actions"

module.exports = React.createClass
  mixins: [FormInstanceMixin, Navigation]

  getInitialState: ->
    @syncStoreStateCollection()

  onStoreChangeCollection: ->
    @setState @syncStoreStateCollection()

    null

  syncStoreStateCollection: ->
    job = JobStore.getState().current or {}
    job.group ?= null
    job.name ?= ""
    job.type ?= null

    {
      job: job
    }

  componentDidMount: ->
    JobStore.listen @onStoreChangeCollection

    null

  componentWillMount: ->
    NavigationActions.setTitle "Job Builder"
    NavigationActions.setNext @onHandleSubmit
    null

  componentWillUnmount: ->
    JobStore.unlisten @onStoreChangeCollection

    null

  changeFormField: (key, value) ->
    job = @state.job
    job[key] = value
    @setState job: job

  handleChange: (event) ->
    event.preventDefault()
    @changeFormField event.target.name, event.target.value

  handleSelect: (field) ->
    (value) =>
      @changeFormField field, value

  getFormData: ->
    @state.job

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

  performSubmit: (formData) ->
    JobActions.create formData
    @transitionTo "component", {component: "concrete"}

  render: ->
    <Form leftLabel={null}
          clickRight={@onHandleSubmit}
          {...@props}>
      <Row>
        <Col xs={12}>
          <ChooseInput type="group" name="group"
                     value={@state.job.group}
                     bsStyle={@getFieldStyle "group"}
                     help={@getFieldErrors "group"}
                     onChange={@handleSelect "group"} />
          </Col>
      </Row>
      <InputField name="name"
             placeholder="Job Name"
             value={@state.job.name}
             bsStyle={@getFieldStyle "name"}
             help={@getFieldErrors "name"}
             onChange={@handleChange} />
      <Row>
        <Col xs={12}>
          <ChooseInput type="job" name="type"
                       value={@state.job.type}
                       bsStyle={@getFieldStyle "type"}
                       help={@getFieldErrors "type"}
                       onChange={@handleSelect "type"} />
        </Col>
      </Row>
    </Form>
