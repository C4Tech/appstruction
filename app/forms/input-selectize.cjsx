
module.exports = React.createClass
  render: ->
    classes =
      "form-group": true
      "has-error": @props.bsStyle is "error"

    helpBlock = <span className="help-block">{@props.help}</span>
    helpBlock = null unless @props.help?.length

    <div className={classNames classes}>
      <Select {...@props} />
      {helpBlock}
    </div>
