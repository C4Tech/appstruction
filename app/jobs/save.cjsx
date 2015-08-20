ChoicesActions = require "choices/actions"
Decoration = require "elements/header-decoration"
EnsureJobMixin = require "mixins/ensure-job"
Form = require "forms/base"
JobActions = require "jobs/actions"
JobReview = require "jobs/review"
JobStore = require "jobs/store"
NavigationActions = require "navigation/actions"
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
    NavigationActions.unsetTitle()
    NavigationActions.unsetNext()
    NavigationActions.setPrev "component", "subcontractor"

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
    <article>
      <header>
        <h2>{@state.job?.name}</h2>
        <h4>Job Overview</h4>
      </header>

      <Form id="save"
            leftLabel="Start Over"
            clickLeft={@handleReset}
            rightLabel="Save"
            clickRight={@handleSave}
            {...@props}>
        <StaticField label="Subtotal"
                     className="lead"
                     value={@state.job.subtotal} />
        <PercentField name="profit-margin" label="Profit Margin"
                      value={@state.job.profitMargin}
                      onChange={@handleChange} />
        <StaticField label="Grand Total"
                     className="lead total"
                     value={@state.job.total} />
      </Form>
      <JobReview job={@state.job} />
    </article>
