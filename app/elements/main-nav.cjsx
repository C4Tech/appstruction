Button = ReactBootstrap.Button

module.exports = React.createClass
  render: ->
    <Button {...@props} navDropdown={true} className="create-link">
      {@props.children}
    </Button>
