Col = ReactBootstrap.Col
Button = ReactBootstrap.Button
Icon = ReactFA.Icon

module.exports = React.createClass
  render: ->
    classes = @prop.className ? {}
    classes["btn-nav"] = true
    classes["ccma-navigate"] = true
    classes["navbar-btn"] = true

    <Col xs={4} xsOffset={@props.offset or 0}>
      <Button {..@props}
              className={classes}
              role="button">
        <Icon name={@props.icon or "arrow-left"} size="2x" />
        <br />
        {@props.label or "Back"}
      </Button>
    </Col>
