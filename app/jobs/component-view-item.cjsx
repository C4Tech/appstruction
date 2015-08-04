Components =
  concrete: require "components/concrete-view"
  equipment: require "components/equipment-view"
  labor: require "components/labor-view"
  material: require "components/material-view"
  subcontractor: require "components/subcontractor-view"

Col = ReactBootstrap.Col
Row = ReactBootstrap.Row

module.exports = React.createClass
  getDefaultProps: ->
    {
      type: null
      item: {}
    }

  render: ->
    Item = Components[@props.type]
    unless Item
      log.error "Component not found: #{@props.type}"
      return null

    <Row>
      <Col xs={12}>
        <Item item={@props.item} />
      </Col>
    </Row>
