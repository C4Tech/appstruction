Button = ReactBootstrap.Button
Row = ReactBootstrap.Row
Col = ReactBootstrap.Col
Input = ReactBootstrap.Input

BaseModal = require "modals/base"
classNames = require "classnames"

module.exports = React.createClass
  getDefaultProps: ->
    {
      submitLabel: "Submit"
      cancelLabel: "Cancel"
      onHandleSubmit: null
      onHandleCancel: null
    }

  render: ->
    cancelButton = <Button className="btn-cancel btn-rounded pull-right"
                           bsSize="large"
                           onClick={@props.onHandleCancel}>
      {@props.cancelLabel or "Cancel"}
    </Button>

    cancelButton = null unless @props.cancelLabel

    footerClasses =
      "btn-rounded": true
      "pull-left": if cancelButton then true else false

    footer = <div className="modal-footer">
        <Button className={classNames footerClasses} bsStyle="primary" bsSize="large" onClick={@props.onHandleSubmit}>{@props.submitLabel or "Submit"}</Button>
        {cancelButton}
      </div>

    <BaseModal {...@props}
               isForm
               footer={footer}>
      {@props.children}

      <div className="text-left text-primary">
        * Required Fields
      </div>
    </BaseModal>
