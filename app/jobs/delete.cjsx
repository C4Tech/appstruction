ChoicesField = require "choices/input-choice"
ChoicesStore = require "choices/store"
JobActions = require "jobs/actions"
JobSelect = require "jobs/input-job"
JobStore = require "jobs/store"

Button = ReactBootstrap.Button
Col = ReactBootstrap.Col
Row = ReactBootstrap.Row

module.exports = React.createClass
  getInitialState: ->
    state = @syncStoreStateCollection()
    state.selectedJob = null
    state

  componentDidMount: ->
    JobStore.listen @onStoreChangeCollection
    ChoicesStore.listen @onStoreChangeCollection
    null

  componentWillUnmount: ->
    JobStore.unlisten @onStoreChangeCollection
    ChoicesStore.unlisten @onStoreChangeCollection
    null

  onStoreChangeCollection: ->
    @setState @syncStoreStateCollection()
    null

  createJobOption: (id, job) ->
    group = ChoicesStore.getLabelFor "group", job.group
    {
      value: id
      label: "#{group}: #{job.name}"
    }

  syncStoreStateCollection: ->
    groups = ChoicesStore.getState().options.group ? []

    jobs = JobStore.getState().data ? {}
    jobOptions = []
    jobOptions.push @createJobOption id, job for own id, job of jobs

    {
      groups: groups
      jobs: jobs
      jobOptions: jobOptions
    }

  handleSelectJob: (value) ->
    return null unless @state.jobs[value]
    @setState
      selectedJob: value

    null

  handleSelectGroup: (value) ->
    @setState
      selectedGroup: value

    null

  handleDeleteJob: (event) ->
    event.preventDefault()
    JobActions.delete @state.selectedJob
    null

  handleDeleteGroup: (event) ->
    event.preventDefault()
    JobActions.deleteGroup @state.selectedGroup
    ChoicesActions.delete "group", @state.selectedGroup
    null

  render: ->
    <article className="browse-jobs">
      <JobSelect name="job"
                 label="Browse Jobs"
                 value={@state.selectedJob}
                 options={@state.jobOptions}
                 onChange={@handleSelectJob} />

      <Row>
        <Col xs={6} xsOffset={6}>
          <Button bsStyle="danger" className="form-control" onClick={@handleDeleteJob}>
            Delete Estimate
          </Button>
        </Col>
      </Row>

      <ChoicesField type="group" name="group"
                    label="Browse Groups"
                    help="Deleting a group also deletes all related jobs"
                    bsStyle="warning"
                    value={@state.selectedGroup}
                    options={@state.groups}
                    onChange={@handleSelectGroup}
                    allowCreate={false} />
    </article>
