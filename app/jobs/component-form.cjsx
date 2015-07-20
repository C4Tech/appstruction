ComponentItem = require "jobs/component-form-item"
Form = require "forms/base"
Icon = require "elements/icon"
InstanceFormMixin = require "mixins/form-instance"
JobStore = require "jobs/store"
Button = ReactBootstrap.Button
Col = ReactBootstrap.Col
Input = ReactBootstrap.Input
Row = ReactBootstrap.Row

module.exports = React.createClass
  mixins: [ReactRouter.State]

  getInitialState: ->
    @syncStoreStateCollection()

  componentDidMount: ->
    JobStore.listen @onStoreChangeCollection
    null

  componentWillUnmount: ->
    JobStore.unlisten @onStoreChangeCollection
    null

  onStoreChangeCollection: ->
    @setState @syncStoreStateCollection()
    null

  syncStoreStateCollection: ->
    type = @getParams().component
    job = JobStore.getState().current
    component = job[type]

    {
      type: type
      items: component?.items ? []
      cost: component?.subtotal
      total: job?.cost
    }

  handleAdd: (event) ->
    null

  handleNext: (event) ->
    null

  handleSave: (event) ->
    null

  render: ->
    addButton = <Row>
        <Button bsStyle="warning" block onClick={@handleAdd}>
          <Icon name="plus-circle" />
          Add another
        </Button>

        <hr />
      </Row>

    addButton = null if @state.type is "concrete"

    <Form handleNext={@handleNext}
          handleSave={@handleSave}>

      {<ComponentItem type={@state.type} item={item} /> for item in @state.items}

      <hr />
      {addButton}

      <Row>
        <div className="lead">
          <div className="capitalize">
            {@state.type} ${@state.cost}
          </div>
          <div>
            Subtotal ${@state.total}
          </div>
        </div>
      </Row>
    </Form>
