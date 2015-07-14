module.exports =
  getInitialState: ->
    @syncStoreStateCollection()

  componentWillMount: ->
    @actions.browse()

  componentDidMount: ->
    @store.listen @onStoreChangeCollection
    null

  componentWillUnmount: ->
    @store.unlisten @onStoreChangeCollection
    null

  onStoreChangeCollection: ->
    @setState @syncStoreStateCollection()
    null

  syncStoreStateCollection: ->
    {
      items: @store.getState().data
      allLoaded: @store.getState().count > 0
    }
