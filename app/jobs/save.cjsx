ChoicesActions = require "choices/actions"
Decoration = require "elements/header-decoration"
EnsureJobMixin = require "mixins/ensure-job"
Form = require "forms/base"
JobActions = require "jobs/actions"
JobReview = require "jobs/review"
JobStore = require "jobs/store"
PercentField = require "forms/input-percentage"
Str = require "util/str"

Col = ReactBootstrap.Col
Navigation = ReactRouter.Navigation
Row = ReactBootstrap.Row
StaticField = ReactBootstrap.FormControls.Static

module.exports = React.createClass
  mixins: [EnsureJobMixin, Navigation]

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
    {
      job: JobStore.getState().current
    }

  handleChange: (event) ->
    name = Str.dashToCamel event.target.name
    data = {}
    data["#{name}"] = event.target.value
    JobActions.update data

    null

  handleReset: ->
    JobActions.setCurrent false
    @transitionTo "home"

    null

  handleSave: ->
    ChoicesActions.save()
    JobActions.save()
    @transitionTo "home"

    null

  render: ->
    <Form leftLabel="Start Over"
          clickLeft={@handleReset}
          rightLabel="Save"
          clickRight={@handleSave}
          {...@props}>
      <Row>
        <Col xs={12}>
          <h3>{@state.job?.name}</h3>
        </Col>
      </Row>

      <Row>
        <Col xs={12} className="header-title">
          <h4>Job Overview
            <Decoration iconType="help" icon="question-circle" />
            <Decoration iconType="email" icon="envelope" />
            <Decoration iconType="pdf" icon="file-pdf-o" />
          </h4>
        </Col>
      </Row>

      <StaticField label="Subtotal"
                   className="lead"
                   value={@state.job.subtotal} />
      <PercentField name="profit-margin" label="Profit Margin"
                    value={@state.job.profitMargin}
                    onChange={@handleChange} />
      <StaticField label="Grand Total"
                   className="lead"
                   value={@state.job.total} />
    </Form>
