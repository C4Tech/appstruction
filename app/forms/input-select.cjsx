Input = ReactBootstrap.Input

module.exports = React.createClass
  render: ->
    <Input {..@props} type="select">
      <option value="" />
      {@props.children}
    </Input>
