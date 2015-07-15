Row = ReactBootstrap.Row
Navigation = ReactRouter.Navigation

Footer = require "layouts/footer"
NavButton = require "layouts/nav-button"

module.exports = React.createClass
  mixins = [Navigation]

  handleNavCreate: (event) ->
    event.preventDefault()
    @transitionTo "job"

  handleNavLoad: (event) ->
    event.preventDefault()
    @transitionTo "load"

  handleNavDelete: (event) ->
    event.preventDefault()
    @transitionTo "delete"

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
