Icon = require "elements/icon"

Button = ReactBootstrap.Button
OverlayTrigger = ReactBootstrap.OverlayTrigger
Popover = ReactBootstrap.Popover

module.exports = React.createClass
  getDefaultProps: ->
    {
      placement: "bottom"
      trigger: "click"
      bsStyle: "plain"
      title: null
      helpText: null

    }

  render: ->
    overlay = <Popover title={@props.title}>
      {@props.helpText}
    </Popover>

    icon = <Icon name="question-circle" size="lg" className="pad-left" />

    button = <span>
      <strong>{@props.title}</strong>
      {icon}
    </span>

    if @props.bsStyle isnt "plain"
      button = <Button bsStyle={@props.bsStyle}>
        <strong>{@props.title}</strong>
        {icon}
      </Button>

    <OverlayTrigger trigger={@props.trigger}
                    placement={@props.placement}
                    overlay={overlay}>
      {button}
    </OverlayTrigger>
