Select = require "forms/input-selectize"

module.exports = React.createClass
  render: ->
    <Select name="job"
      addLabelText="{label}"
      {...@props} />
