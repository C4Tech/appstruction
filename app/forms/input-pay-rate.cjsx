Select = require "forms/input-selectize"
Time = require "util/time"

module.exports = React.createClass
  render: ->
    <Select help="Dropdown help"
      name={@props.type}
      addLabelText="{label}"
      {...@props}
      options={Time.options.rate} />
