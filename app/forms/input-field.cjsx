Input = ReactBootstrap.Input

module.exports = React.createClass
  render: ->
    type = @props.type ? "text"

    <Input {...@props} type={type} />
