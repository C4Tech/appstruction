ComponentItem = require "jobs/component-form-item"
EnsureJobMixin = require "mixins/ensure-job"
Form = require "forms/base"
Icon = require "elements/icon"
InstanceFormMixin = require "mixins/form-instance"
JobActions = require "jobs/actions"
JobStore = require "jobs/store"
NavigationStore = require "navigation/store"

Button = ReactBootstrap.Button
Col = ReactBootstrap.Col
Input = ReactBootstrap.Input
Navigation = ReactRouter.Navigation
Row = ReactBootstrap.Row
State = ReactRouter.State

module.exports = React.createClass
  mixins: [EnsureJobMixin, Navigation, State]

  getInitialState: ->
    @syncStoreStateCollection()

  componentDidMount: ->
    JobStore.listen @onStoreChangeCollection
    NavigationStore.listen @onStoreChangeCollection

    type = @getParams().component
    component = @state.job?.components?[type]
    @addComponent() unless component?

    null

  componentWillUnmount: ->
    JobStore.unlisten @onStoreChangeCollection
    NavigationStore.unlisten @onStoreChangeCollection
    null

  onStoreChangeCollection: ->
    @setState @syncStoreStateCollection()
    null

  syncStoreStateCollection: ->
    type = @getParams().component
    job = JobStore.getState().current
    component = job?.components?[type]

    {
      type: type
      items: component?.items ? []
      cost: component?.cost ? 0.00
      total: job?.subtotal ? 0.00
      nav: NavigationStore.getState().data
    }

  handleAdd: (event) ->
    event.preventDefault()
    @addComponent()

    null

  handleNext: (event) ->
    event.preventDefault()
    @transitionTo @state.nav.next,
      component: @state.nav.nextParam

    null

  handleSave: (event) ->
    event.preventDefault()
    JobActions.save()
    @transitionTo "home"

    null

  addComponent: ->
    JobActions.createComponent @getParams().component, {}

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
