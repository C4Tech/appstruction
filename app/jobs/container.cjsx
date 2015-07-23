RouteHandler = ReactRouter.RouteHandler

Decoration = require "elements/header-decoration"
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
      job: JobStore.getState().current
      title: NavigationStore.getState().title
    }

  render: ->
    pageTitle = <div className="header-title">
      <h4>
        {@state.title}

        <Decoration iconType="help" icon="question-circle" />
        <Decoration iconType="email" icon="envelope" />
        <Decoration iconType="pdf" icon="file-pdf-o" />
      </h4>
    </div>
    pageTitle = null unless @state.title

    <div>
      <h3>{@state.job?.name}</h3>
      {pageTitle}

      <RouteHandler />
    </div>
