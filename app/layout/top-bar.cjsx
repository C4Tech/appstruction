Navbar = ReactBootstrap.Navbar
Navigation = ReactRouter.Navigation
Row = ReactBootstrap.Row

NavButton = require "elements/nav-button"
NavigationStore = require "navigation/store"

module.exports = React.createClass
  mixins: [Navigation]

  getInitialState: ->
    @syncStoreStateCollection()

  componentDidMount: ->
    NavigationStore.listen @onStoreChangeCollection
    null

  componentWillUnmount: ->
    NavigationStore.unlisten @onStoreChangeCollection
    null

  onStoreChangeCollection: ->
    @setState @syncStoreStateCollection()
    null

  syncStoreStateCollection: ->
    NavigationStore.getState().data

  handleNavBack: (event) ->
    event.preventDefault()
    @transitionTo @state.prev,
      component: @state.prevParam
    null

  handleNavHome: (event) ->
    event.preventDefault()
    @transitionTo "home"
    null

  handleNavNext: (event) ->
    event.preventDefault()
    @transitionTo @state.next,
      component: @state.nextParam
    null

  render: ->
    prev = <NavButton label="Back"
              icon="arrow-left"
              className={"prev": true}
              onClick={@handleNavBack}></NavButton>
    prev = null unless @state.prev

    next = <NavButton label="Next"
              icon="arrow-right"
              className={"next": true, "pull-right": true}
              onClick={@handleNavNext}></NavButton>
    next = null unless @state.next

    <Navbar>
      <Row>
        {prev}

        <NavButton label="Home"
            icon="home"
            className={"home": true, "center-block": true}
            offset={4 unless @state.prev}
            onClick={@handleNavHome} />

        {next}
      </Row>
    </Navbar>

