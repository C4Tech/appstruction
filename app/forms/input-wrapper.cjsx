Col = ReactBootstrap.Col
Row = ReactBootstrap.Row

module.exports = React.createClass
  render: ->
    <Row>
      <Col xs={12}>
        {@props.children}
      </Col>
    </Row>
