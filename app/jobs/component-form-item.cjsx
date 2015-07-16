InstanceFormMixin = require "mixins/form-instance"
Button = ReactBootstrap.Button
Col = ReactBootstrap.Col
Row = ReactBootstrap.Row

module.exports = React.createClass
  render: ->
    Item = require "components/#{@props.type}-form"

    <Row>
      <Item item={@props.item} />
    </Row>
