ComponentItem = require "jobs/component-form-item"
InstanceFormMixin = require "mixins/form-instance"
Button = ReactBootstrap.Button
Col = ReactBootstrap.Col
Input = ReactBootstrap.Input
Row = ReactBootstrap.Row

module.exports = React.createClass
  mixins: [ReactRouter.State]

  render: ->
    type = @getParam "component"

    addButton = <Row>
        <div>
          <Button bsStyle="warning">
            <Icon name="plus-circle" />
            Add another
          </Button>
        </div>
      </Row>

    addButton = null if @state.type is "concrete"

    <Form submitLabel="Next"
          onHandleSubmit={@onHandleSubmit}
          {...@props}>
      {<ComponentItem type={@state.type} item={item} /> for item in @state.items}

      <hr />

      {addButton}
      {<hr /> unless @state.type is "concrete"}

      <Row>
        <div className="lead">
          <span className="capitalize">{@state.type}</span>
          $<span className="{@props.type} cost">{@state.cost}</span>
          <br />
          Subtotal $<span className="subtotal">{@state.total}</span>
        </div>
      </Row>
    </Form>
