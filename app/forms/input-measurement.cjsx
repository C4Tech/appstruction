Select = require "forms/input-selectize"
Measure = require "util/measure"

module.exports = React.createClass
  render: ->
    <Select name={@props.type}
      addLabelText="{label}"
      placeholder="Unit"
      {...@props}
      options={Measure.options.linear} />
