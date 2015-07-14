CollectionApiMixin = require "mixins/api-collection"
JobSelect = require "jobs/input-job"
Button = ReactBootstrap.Button
Col = ReactBootstrap.Col
Link = ReactRouter.Link
Row = ReactBootstrap.Row

module.exports = React.createClass
  mixins: [CollectionApiMixin]

  handleLoad: (event) ->
    event.preventDefault()
    @transitionTo "home"

  render: ->
    <article>
      <JobSelect jobs={@state.jobs} />

      <Row>
        <Col xs={6} xsOffset={6}>
          <Button className="form-control" onClick={@handleLoad}>Load Estimate</button>
        </Col>
      </Row>
    </article>
