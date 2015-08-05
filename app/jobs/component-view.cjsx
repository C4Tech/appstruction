ComponentItem = require "jobs/component-view-item"
Icon = require "elements/icon"

Button = ReactBootstrap.Button
Col = ReactBootstrap.Col
ListGroup = ReactBootstrap.ListGroup
Panel = ReactBootstrap.Panel
Row = ReactBootstrap.Row

module.exports = React.createClass
  getDefaultProps: ->
    {
      type: null
      editable: false
      items: []
    }

  render: ->
    return null unless @props.component.items.length
    items = @props.component.items

    edit = <Button bsStyle="warning">
      <Icon name="edit" size="lg" />
      Edit
    </Button>
    edit = null unless @props.editable

    <Panel header="#{@props.type}"
           className="panel-overview"
           collapsible
           defaultExpanded={false}>
      <Row>
        <Col xs={8}>
          <h4>Cost: ${@props.component.cost}</h4>
        </Col>
        <Col xs={4}>
          {edit}
        </Col>
      </Row>

      <Row>
        <Col xs={12}>
          <ListGroup fill>
            {<ComponentItem type={@props.type} item={item} /> for item in items}
          </ListGroup>
        </Col>
      </Row>
    </Panel>
