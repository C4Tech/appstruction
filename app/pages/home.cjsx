Row = ReactBootstrap.Row
Navigation = ReactRouter.Navigation

Footer = require "layout/footer"
NavButton = require "elements/main-nav"

module.exports = React.createClass
  mixins: [Navigation]

  handleNavCreate: (event) ->
    event.preventDefault()
    @transitionTo "add"

  handleNavLoad: (event) ->
    event.preventDefault()
    @transitionTo "load"

  handleNavDelete: (event) ->
    event.preventDefault()
    @transitionTo "delete"

  render: ->
    <div>
      <Row componentClass="article">
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
