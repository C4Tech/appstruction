Button = ReactBootstrap.Button

module.exports = React.createClass
  render: ->
    <Button {...@props} navDropdown={true} className="btn-main-nav lead">
      {@props.children}
    </Button>
