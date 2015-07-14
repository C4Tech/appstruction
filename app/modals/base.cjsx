Button = ReactBootstrap.Button
Modal = ReactBootstrap.Modal

classNames = require "classnames"

module.exports = React.createClass
  getDefaultProps: ->
    {
      isForm: false
      style: "primary"
    }

  render: ->
    footer = <div className="modal-footer">
        <Button onClick={@props.onRequestHide}>Close</Button>
      </div>
    footer = @props.footer if @props.footer?

    modalClasses =
      "modal-form": @props.isForm

    bodyClasses =
      "modal-body": true

    <Modal
      className={classNames modalClasses}
      bsStyle={@props.style}
      bsSize={@props.size}
      {...@props}>

      <div className={classNames bodyClasses}>
          {@props.children}
      </div>

      {footer}
    </Modal>
