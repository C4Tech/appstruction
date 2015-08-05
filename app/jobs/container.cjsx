Col = ReactBootstrap.Col
RouteHandler = ReactRouter.RouteHandler
Row = ReactBootstrap.Row

JobStore = require "jobs/store"
NavigationStore = require "navigation/store"

module.exports = React.createClass
  getInitialState: ->
    @syncStoreStateCollection()

  componentDidMount: ->
    JobStore.listen @onStoreChangeCollection
    NavigationStore.listen @onStoreChangeCollection
    null

  componentWillUnmount: ->
    JobStore.unlisten @onStoreChangeCollection
    NavigationStore.unlisten @onStoreChangeCollection
    null

  onStoreChangeCollection: ->
    @setState @syncStoreStateCollection()
    null

  syncStoreStateCollection: ->
    {
      job: JobStore.getState().current?.name
      title: NavigationStore.getState().data?.title
    }

  render: ->
    <div>
      <Row className="job-title">
        <Col xs={12}>
          <h3>{@state.job}</h3>
        </Col>
      </Row>

      <Row className="job-subtitle">
        <Col xs={12} className="text-capitalize">
          {<h4>{@state.title}</h4> if @state.title}
        </Col>
      </Row>

      <Row componentClass="article">
        <Col xs={12}>
          <RouteHandler />
        </Col>
      </Row>
    </div>
