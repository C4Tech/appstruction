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
Panel = ReactBootstrap.Panel
Row = ReactBootstrap.Row

module.exports = React.createClass
  mixins: [EnsureJobMixin, ReactRouter.Navigation]

  getInitialState: ->
    @syncStoreStateCollection()

  componentDidMount: ->
    JobStore.listen @onStoreChangeCollection
    NavigationStore.listen @onStoreChangeCollection
    @ensureComponentExists()

    null

  componentDidUpdate: ->
    @ensureComponentExists()

    null

  ensureComponentExists: ->
    @addComponent() if @state.items.length is 0

    null

  componentWillUnmount: ->
    JobStore.unlisten @onStoreChangeCollection
    NavigationStore.unlisten @onStoreChangeCollection

    null

  onStoreChangeCollection: ->
    @setState @syncStoreStateCollection()

    null

  syncStoreStateCollection: ->
    type = @props.params.component
    job = JobStore.getState().current
    component = job?.components?[type]

    {
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
    return @state.nav.next event if typeof @state.nav.next is "function"
    @transitionTo @state.nav.next,
      component: @state.nav.nextParam

    null

  handleSave: (event) ->
    event.preventDefault()
    JobActions.save()
    return @state.nav.prev event if typeof @state.nav.prev is "function"
    @transitionTo @state.nav.prev,
      component: @state.nav.prevParam

    null

  addComponent: ->
    JobActions.upsertComponent @props.params.component, {}

    null

  render: ->
    type = @props.params.component
    return null unless type

    <Form clickRight={@handleNext}
          clickLeft={@handleSave}>

      {<ComponentItem type={type} item={item} /> for item in @state.items}

      <Row>
        <Col xs={12}>
          <Button bsStyle="warning" block onClick={@handleAdd}>
            <Icon name="plus-circle" />
            Add another
          </Button>

          <hr />
        </Col>
      </Row>

      <Row>
        <Col xs={12}>
          <Panel className="lead panel-totals text-capitalize">
            <Row>
              <Col xs={12}>
                {type} ${@state.cost}
              </Col>
            </Row>

            <Row>
              <Col xs={12}>
                Subtotal ${@state.total}
              </Col>
            </Row>
          </Panel>
        </Col>
      </Row>
    </Form>
