Navigation = ReactRouter.Navigation
Button = ReactBootstrap.Button
PageHeader = ReactBootstrap.PageHeader

classNames = require "classnames"

module.exports = React.createClass
  mixins: [Navigation]

  getDefaultProps: ->
    {
      isModal: false
      title: false
      submitLabel: "Submit"
      cancelLabel: "Cancel"
      onHandleCancel: @handleCancel
      onHandleSubmit: @handleSubmit
    }

  handleSubmit: (event) ->
    event.preventDefault()
    console.log "Nothing is configured to handle form submission"
    null

  handleCancel: (event) =>
    event.preventDefault()
    @goBack()
    null

  render: ->
    title = <PageHeader>{@props.title}</PageHeader>
    title = null unless @props.title

    cancelButton = <Button className="btn-cancel btn-rounded pull-right" bsSize="large" onClick={@props.onHandleCancel}>{@props.cancelLabel or "Cancel"}</Button>
    cancelButton = null unless @props.cancelLabel

    footerClasses =
      "btn-rounded": true
      "pull-left": if cancelButton then true else false

    <form>
      {title}

      {@props.children}

      <div className="text-left text-primary">
        * Required Fields
      </div>

      <div className="form-footer">
        <Button className={classNames footerClasses} bsStyle="primary" bsSize="large" onClick={@props.onHandleSubmit}>{@props.submitLabel or "Submit"}</Button>
        {cancelButton}
      </div>
    </form>
