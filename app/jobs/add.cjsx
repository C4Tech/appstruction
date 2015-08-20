ChooseInput = require "choices/input-choice"
Form = require "forms/base"
FormInstanceMixin = require "mixins/form-instance"
ComponentFormMixin = require "mixins/component-form"
Help = require "elements/help"
InputField = require "forms/input-field"
JobActions = require "jobs/actions"
JobStore = require "jobs/store"
NavigationActions = require "navigation/actions"
Str = require "util/str"

module.exports = React.createClass
  mixins: [
    FormInstanceMixin,
    ComponentFormMixin,
    ReactRouter.Navigation
  ]

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
    NavigationActions.unsetTitle()
    NavigationActions.setNext @onHandleSubmit
    NavigationActions.unsetPrev()

    null

  componentWillUnmount: ->
    JobStore.unlisten @onStoreChangeCollection

    null

  changeFormField: (key, value) ->
    job = @state.job
    job[key] = value
    @setState job: job

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
    <article>
      <header>
        <h2>Job Builder</h2>
      </header>
      <Form id="create"
            leftLabel={null}
            clickRight={@onHandleSubmit}
            {...@props}>
        <ChooseInput type="group" name="group"
                     label="Group name"
                     className="group-name"
                     value={@state.job.group}
                     bsStyle={@getFieldStyle "group"}
                     help={@getFieldErrors "group"}
                     onChange={@handleSelectCreate "group"} />
        <InputField name="name"
               label="Job name"
               value={@state.job.name}
               bsStyle={@getFieldStyle "name"}
               help={@getFieldErrors "name"}
               onChange={@handleChange} />
        <ChooseInput type="job" name="type"
                     label={<Help title="What type of job" helpText={Str.dropdown} />}
                     className="job-type"
                     value={@state.job.type}
                     bsStyle={@getFieldStyle "type"}
                     help={@getFieldErrors "type"}
                     onChange={@handleSelect "type"} />
      </Form>
    </article>
