InstanceFormMixin = require "mixins/form-instance"
Button = ReactBootstrap.Button
Col = ReactBootstrap.Col
Input = ReactBootstrap.Input
Row = ReactBootstrap.Row

module.exports = React.createClass
  render: ->
    <Form submitLabel="Next"
          onHandleSubmit={@onHandleSubmit}
          {...@props}>
      <Row>
        <ChooseInput type="group"
                     value={@state.form.group}
                     bsStyle={@getFieldStyle "group"}
                     help={@getFieldErrors "group"}
                     onChange={@handleChange} />
      </Row>
      <Row>
        <Input type="text"
               name="name"
               placeholder="Job Name"
               value={@state.form.name}
               bsStyle={@getFieldStyle "name"}
               help={@getFieldErrors "name"}
               onChange={@handleChange} />
      </Row>
      <Row>
        <ChooseInput type="type"
                     value={@state.form.type}
                     bsStyle={@getFieldStyle "type"}
                     help={@getFieldErrors "type"}
                     onChange={@handleChange} />
      </Row>
    </Form>
