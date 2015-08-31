Components =
  concrete: require "components/concrete-form"
  equipment: require "components/equipment-form"
  labor: require "components/labor-form"
  material: require "components/material-form"
  subcontractor: require "components/subcontractor-form"

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

    <Row className="item">
      <Col xs={12}>
        <Item item={@props.item} />
        <hr />
      </Col>
    </Row>
