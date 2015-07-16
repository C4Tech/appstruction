module.exports = React.createClass
  render: ->
    <option value={@props.job.id}>{@props.job.name}</option>
