Button = ReactBootstrap.Button
Col = ReactBootstrap.Col
Navigation = ReactRouter.Navigation
PageHeader = ReactBootstrap.PageHeader
Row = ReactBootstrap.Row

module.exports = React.createClass
  mixins: [Navigation]

  getDefaultProps: ->
    {
      clickLeft: @handleSubmit
      clickRight: @handleSubmit
      leftLabel: "Save & Exit"
      rightLabel: "Next"
      title: false
    }

  handleSubmit: (event) ->
    event.preventDefault()
    console.log "Nothing is configured to handle form submission"
    null

  render: ->
    title = <PageHeader>{@props.title}</PageHeader>
    title = null unless @props.title

    rightButton = <Button bsStyle="success" block onClick={@props.clickRight}>
        {@props.rightLabel or "Next"}
      </Button>
    rightButton = null unless @props.clickRight

    leftButton = <Button bsStyle="primary" block onClick={@props.clickLeft}>
        {@props.leftLabel}
      </Button>
    leftButton = null unless @props.leftLabel

    <form>
      {title}

      {@props.children}

      <Row className="form-footer">
        <Col xs={6}>
          {leftButton}
        </Col>
        <Col xs={6}>
          {rightButton}
        </Col>
      </Row>
    </form>
