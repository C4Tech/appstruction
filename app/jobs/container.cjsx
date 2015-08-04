RouteHandler = ReactRouter.RouteHandler

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
    pageTitle = <div className="header-title">
      <h4>
        {@state.title}
      </h4>
    </div>
    pageTitle = null unless @state.title

    <div>
      <h3>{@state.job}</h3>
      {pageTitle}

      <RouteHandler />
    </div>
