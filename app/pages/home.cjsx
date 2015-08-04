Footer = require "layout/footer"
NavButton = require "elements/main-nav"
NavigationActions = require "navigation/actions"

Row = ReactBootstrap.Row
Navigation = ReactRouter.Navigation

module.exports = React.createClass
  mixins: [Navigation]

  componentWillMount: ->
    NavigationActions.unsetTitle()
    NavigationActions.unsetNext()
    NavigationActions.unsetPrev()
    null


  handleNavTo: (to) ->
    (event) =>
      event.preventDefault()
      @transitionTo to

  render: ->
    <div>
      <Row componentClass="article">
        <div className="lead">
          <NavButton onClick={@handleNavTo "add"}>
            Create new estimate
          </NavButton>

          <hr />

          <NavButton onClick={@handleNavTo "load"}>
            Load saved estimate
          </NavButton>

          <hr />

          <NavButton onClick={@handleNavTo "delete"}>
            Delete saved estimate
          </NavButton>
        </div>
      </Row>

      <Footer />
    </div>
