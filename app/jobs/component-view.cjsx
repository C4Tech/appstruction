ComponentItem = require "jobs/component-view-item"

Col = ReactBootstrap.Col
Panel = ReactBootstrap.Panel
Row = ReactBootstrap.Row

module.exports = React.createClass
  getDefaultProps: ->
    {
      type: null
      items: []
    }

  render: ->
    return null unless @props.items.length

    <Panel header={@props.type}>
      <Row>
        <Col xs={10}>
          {<ComponentItem type={type} item={item} /> for item in @props.items}
        </Col>
        <Col xs={2}>
          Edit
        </Col>
      </Row>
    </Panel>
