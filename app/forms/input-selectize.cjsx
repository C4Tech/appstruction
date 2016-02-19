Wrapper = require "forms/input-wrapper"

Col = ReactBootstrap.Col
Row = ReactBootstrap.Row

module.exports = React.createClass
  getDefaultProps: ->
    {
      isVertical: true
    }

  render: ->
    classes =
      "form-group": true
      "has-error": @props.bsStyle is "error"
      "has-warning": @props.bsStyle is "warning"

    helpBlock = <span className="help-block">{@props.help}</span>
    helpBlock = null unless @props.help

    label = <label className="control-label">
      <span>{@props.label}</span>
    </label>
    label = null unless @props.label

    output = <div className={classNames classes}>
      {label}
      <Select {...@props} />
      {helpBlock}
    </div>

    return output unless @props.isVertical

    <Wrapper>
      {output}
    </Wrapper>

