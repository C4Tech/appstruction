Button = ReactBootstrap.Button
Col = ReactBootstrap.Col
Navigation = ReactRouter.Navigation
PageHeader = ReactBootstrap.PageHeader
Row = ReactBootstrap.Row

module.exports = React.createClass
  mixins: [Navigation]

  getDefaultProps: ->
    {
      isModal: false
      title: false
      submitLabel: "Next"
      saveLabel: "Save &amp; Exit"
      handleSave: @handleSubmit
      handleNext: @handleSubmit
    }

  handleSubmit: (event) ->
    event.preventDefault()
    console.log "Nothing is configured to handle form submission"
    null

  render: ->
    title = <PageHeader>{@props.title}</PageHeader>
    title = null unless @props.title

    nextButton = <Button bsStyle="success" block onClick={@props.handleNext}>
        {@props.submitLabel or "Next"}
      </Button>
    nextButton = null unless @props.handleNext

    saveButton = <Button bsStyle="primary" block onClick={@props.handleSave}>
        {@props.saveLabel}
      </Button>
    saveButton = null unless @props.saveLabel

    <form>
      {title}

      {@props.children}

      <Row className="form-footer">
        <Col xs={6}>
          {saveButton}
        </Col>
        <Col xs={6}>
          {nextButton}
        </Col>
      </Row>
    </form>
