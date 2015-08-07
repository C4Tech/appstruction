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
    <article>
      <header>
        <h2>{@state.job}</h2>
        {<h4 className="text-capitalize">{@state.title}</h4> if @state.title}
      </header>

      <Row>
        <Col xs={12}>
          <RouteHandler />
        </Col>
      </Row>
    </article>
