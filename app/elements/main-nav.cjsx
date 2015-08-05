Button = ReactBootstrap.Button

module.exports = React.createClass
  render: ->
    <Button {...@props} navDropdown={true} className="btn-main-nav">
      {@props.children}
    </Button>
