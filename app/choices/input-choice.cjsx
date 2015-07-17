JobActions = require "jobs/actions"
ChoicesStore = require "choices/store"
Select = require "forms/input-selectize"

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
    <Select help="Dropdown help"
      name={@props.type}
      allowCreate
      addLabelText="{label}"
      {...@props}
      options={@state.options} />
