Navbar = ReactBootstrap.Navbar
Row = ReactBootstrap.Row

NavButton = require "layouts/nav-button"

module.exports = React.createClass
  handleNavBack: (event) ->
    null

  handleNavHome: (event) ->
    null

  handleNavNext: (event) ->
    null

  render: ->
    prev = <NavButton label="Back"
              icon="arrow-left"
              className={"prev": true}
              onClick={@handleNavBack} />

    next = <NavButton label="Next"
              icon="arrow-right"
              className={"next": true, "pull-right": true}
              onClick={@handleNavNext} />

    <Navbar>
      <Row>
        {prev if @state.nav.prev}

        <NavButton label="Home"
            icon="home"
            className={"home": true, "center-block": true}
            offset={4 unless @state.nav.prev}
            onClick={@handleNavHome} />

        {next if @state.nav.next}
      </Row>
    </Navbar>

