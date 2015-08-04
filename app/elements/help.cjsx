Icon = require "elements/icon"

Button = ReactBootstrap.Button
OverlayTrigger = ReactBootstrap.OverlayTrigger
Popover = ReactBootstrap.Popover

module.exports = React.createClass
  getDefaultProps: ->
    {
      placement: "bottom"
      trigger: "click"
      bsStyle: "link"
      title: null
      helpText: null
    }

  render: ->
    overlay = <Popover title={@props.title}>
      {@props.helpText}
    </Popover>

    <OverlayTrigger trigger={@props.trigger}
                    placement={@props.placement}
                    overlay={overlay}>
      <Button bsStyle={@props.bsStyle}>
        <strong>{@props.title}</strong>
        <Icon name="question-circle" />
      </Button>
    </OverlayTrigger>
