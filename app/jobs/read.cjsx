ChoicesStore = require "choices/store"
Component = require "jobs/component-view"
Decoration = require "elements/header-decoration"
JobStore = require "jobs/store"

Panel = ReactBootstrap.Panel

types = ["concrete", "equipment", "labor", "material", "subcontractor"]

module.exports = React.createClass
  mixins: [ReactRouter.Navigation]

  getInitialState: ->
    @syncStoreStateCollection()

  componentWillMount: ->
    @transitionTo "browse" unless JobStore.getState().current.components?

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
    }

  render: ->
    items = @state.job.components

    <article className="job-summary">
      <header>
        <h2 className="text-capitalize">{@state.job.name}</h2>
        <h4 className="text-capitalize">
          {ChoicesStore.getLabelFor "group", @state.job.group}
        </h4>
      </header>
      <Panel header="Cost: #{@state.job.total}" bsStyle="primary">
        {<Component type={type} component={items[type]} /> for type in types when items?[type]?.cost}
      </Panel>
    </article>

