module.exports =
  getInitialState: ->
    @syncStoreStateInstance()

  componentDidMount: ->
    @store.listen @onStoreChangeInstance
    null

  componentWillUnmount: ->
    @store.unlisten @onStoreChangeInstance
    null

  onStoreChangeInstance: ->
    @setState @syncStoreStateInstance()
    null

  syncStoreStateInstance: ->
    item = @getItemFromStore()
    {
      itemLoaded: if item? and item then true else false
      item: item
    }
