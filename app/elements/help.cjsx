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

    button = <span>
      <strong>{@props.title}</strong>
      <Icon name="question-circle" className="pad-left" />
    </span>

    if @props.bsStyle isnt "plain"
      button = <Button bsStyle={@props.bsStyle}>
        <strong>{@props.title}</strong>
        <Icon name="question-circle" pull="right" />
      </Button>

    <OverlayTrigger trigger={@props.trigger}
                    placement={@props.placement}
                    overlay={overlay}>
      {button}
    </OverlayTrigger>
