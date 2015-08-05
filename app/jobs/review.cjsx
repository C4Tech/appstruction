Component = require "jobs/component-view"
Help = require "elements/help"

Col = ReactBootstrap.Col
Panel = ReactBootstrap.Panel
Row = ReactBootstrap.Row

types = ["concrete", "equipment", "labor", "material", "subcontractor"]

module.exports = React.createClass
  getDefaultProps: ->
    {
      job: {}
    }

  render: ->
    components = @props.job.components

    <article>
      <Row>
        <Col xs={12} className="lead">
          <Help title="Job details" helpText="View the details of your job below.
            You may edit any line item once you expand it. You can also Start
            Over or Save below, and you can email the estimate or save a PDF to
            your mobile device by using the buttons on the top right of this
            screen." />
        </Col>
      </Row>

      <Panel bsStyle="primary">
        {<Component type={type} items={components?[type]} /> for type in types}
      </Panel>
    </article>
