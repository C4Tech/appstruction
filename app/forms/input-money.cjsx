Field = require "forms/input-field"

module.exports = React.createClass
  render: ->
    <Field {...@props} addonBefore="$" />
