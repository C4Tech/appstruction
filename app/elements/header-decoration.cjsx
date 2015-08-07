Icon = require "elements/icon"

module.exports = React.createClass
  render: ->
    <span {...@props} className="btn-icon pull-right">
      <Icon name={@props.icon} />
    </span>
