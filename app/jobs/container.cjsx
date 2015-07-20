RouteHandler = ReactRouter.RouteHandler

Decoration = require "elements/header-decoration"
JobStore = require "jobs/store"

module.exports = React.createClass
  getInitialState: ->
    @syncStoreStateCollection()

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
      job: JobStore.getState().current
      title: "Static Title"
    }

  render: ->
    <div>
      <h3>{@state.job?.name}</h3>

      <div className="header-title">
        <h3>
          {@state.title}

          <Decoration iconType="help" icon="question-circle" />
          <Decoration iconType="email" icon="envelope" />
          <Decoration iconType="pdf" icon="file-pdf-o" />
        </h3>
      </div>

      <RouteHandler />
    </div>
