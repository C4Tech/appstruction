Form = require "forms/base"
JobActions = require "jobs/actions"
JobSelect = require "jobs/input-job"
JobStore = require "jobs/store"

Button = ReactBootstrap.Button
Col = ReactBootstrap.Col
Row = ReactBootstrap.Row

module.exports = React.createClass
  mixins: [ReactRouter.Navigation]

  getInitialState: ->
    state = @syncStoreStateCollection()
    state.selectedJob = null
    state

  componentDidMount: ->
    JobStore.listen @onStoreChangeCollection
    null

  componentWillUnmount: ->
    JobStore.unlisten @onStoreChangeCollection
    null

  onStoreChangeCollection: ->
    @setState @syncStoreStateCollection()
    null

  createSelectOption: (id, label) ->
    {
      value: id
      label: label
    }

  syncStoreStateCollection: ->
    jobs = JobStore.getState().data ? {}
    options = []
    options.push @createSelectOption id, job.name for own id, job of jobs

    {
      jobs: jobs
      options: options
    }

  handleSelect: (value) ->
    return null unless @state.jobs[value]
    @setState
      selectedJob: value

    null

  handleLoad: (event) ->
    event.preventDefault()
    JobActions.setCurrent @state.jobs[@state.selectedJob]
    @transitionTo "read"

  render: ->
    <Form leftLabel={null}
          rightLabel="Load Estimate"
          clickRight={@handleLoad}>
      <JobSelect name="job"
                 label="Browse Jobs"
                 value={@state.selectedJob}
                 options={@state.options}
                 onChange={@handleSelect} />
    </Form>
