Select = require "forms/input-selectize"
Measure = require "util/measure"

module.exports = React.createClass
  render: ->
    <Select help="Dropdown help"
      name={@props.type}
      addLabelText="{label}"
      {...@props}
      options={Measure.options.volume} />
