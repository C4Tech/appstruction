Col = ReactBootstrap.Col
Button = ReactBootstrap.Button
Icon = require "elements/icon"

module.exports = React.createClass
  render: ->
    classes = @props.className ? {}
    classes["btn-nav"] = true
    classes["navbar-btn"] = true

    <Col xs={4} xsOffset={@props.offset or 0}>
      <Button {...@props} className={classes}>
        <Icon name={@props.icon or "arrow-left"} size="2x" />
        <div>{@props.label or "Back"}</div>
      </Button>
    </Col>
