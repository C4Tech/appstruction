Row = ReactBootstrap.Row

Footer = require "layouts/footer"
NavButton = require "layouts/nav-button"

module.exports = React.createClass
  handleNavCreate: (event) ->
    null

  handleNavLoad: (event) ->
    null

  handleNavDelete: (event) ->
    null

  render: ->
    <div>
      <Row>
        <div className="lead">
          <NavButton onClick={@handleNavCreate}>
            Create new estimate
          </NavButton>

          <hr />

          <NavButton onClick={@handleNavLoad}>
            Load saved estimate
          </NavButton>

          <hr />

          <NavButton onClick={@handleNavDelete}>
            Delete saved estimate
          </NavButton>
        </div>
      </Row>

      <Footer />
    </div>
