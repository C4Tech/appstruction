Select = require "forms/input-selectize"
Time = require "util/time"

module.exports = React.createClass
  render: ->
    <Select name={@props.type}
      addLabelText="{label}"
      placeholder="Unit"
      {...@props}
      options={Time.options.time} />
