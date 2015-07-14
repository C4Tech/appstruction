OptionItem = require "jobs/option-item"

module.exports = React.createClass
  render: ->
    <optgroup label="Group: {{@props.group.name}}">
      {<OptionItem job={job} /> for job in @props.group.jobs}
    </optgroup>
