Button = ReactBootstrap.Button

module.exports = React.createClass
  render: ->
    <Button navDropdown={true} className="create-link">
      {@props.children}
    </Button>
