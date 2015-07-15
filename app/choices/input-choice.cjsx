JobActions = require "jobs/actions"
ChoicesStore = require "choices/store"

module.exports = React.createClass
  getInitialState: ->
    @syncStoreStateCollection()

  componentDidMount: ->
    ChoicesStore.listen @onStoreChangeCollection
    null

  componentWillUnmount: ->
    ChoicesStore.unlisten @onStoreChangeCollection
    null

  onStoreChangeCollection: ->
    @setState @syncStoreStateCollection()
    null

  syncStoreStateCollection: ->
    {
      options: ChoicesStore.getState().options[@props.type] ? []
    }

  render: ->
    <Select {..@props}
      name={@props.type}
      options={@state.options} />
