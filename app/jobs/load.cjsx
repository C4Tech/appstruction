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
    null

  componentWillUnmount: ->
    JobStore.unlisten @onStoreChangeCollection
    null

  onStoreChangeCollection: ->
    @setState @syncStoreStateCollection()
    null

  syncStoreStateCollection: ->
    {
      jobs: JobStore.getState().data
    }

  handleSelect: (event) ->
    @setState selectedJob: event.target.value()
    null

  handleLoad: (event) ->
    event.preventDefault()
    JobActions.setCurrent @state.selectedJob
    @transitionTo "home"

  render: ->
    <article className="browse-jobs">
      <JobSelect jobs={@state.jobs} onChange={@handleSelect} />

      <Row>
        <Col xs={6} xsOffset={6}>
          <Button className="form-control" onClick={@handleLoad}>
            Load Estimate
          </Button>
        </Col>
      </Row>
    </article>
