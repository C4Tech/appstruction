InstanceFormMixin = require "mixins/form-instance"
Button = ReactBootstrap.Button
Col = ReactBootstrap.Col
Input = ReactBootstrap.Input
Row = ReactBootstrap.Row

module.exports = React.createClass
  getInitialState: ->
    {
      form:
        group: null
        name: ""
        type: null
      errors: {}
    }

  handleChange: (event) ->
    event.preventDefault()
    form = @state.form
    form[event.target.name] = event.target.value
    @setState form: form

  handleNext: (event) ->
    event.preventDefault()
    JobActions.create @state.form, @props.nav.next if @validate()

  validate: ->
    errors =
      name: []
      group: []
      type: []

    requiredText = "This field is required"

    errors.group.push requiredText unless @state.form.group
    errors.name.push requiredText unless @state.form.name
    errors.type.push requiredText unless @state.form.type
    @setState errors: errors

    response = true
    response = false for own field, messages of errors when messages.length
    response

  render: ->
    <Form saveLabel={null}
          handleNext={@handleNext}
          {...@props}>
      <Row>
        <ChooseInput type="group"
                     value={@state.form.group}
                     bsStyle={@getFieldStyle "group"}
                     help={@getFieldErrors "group"}
                     onChange={@handleChange} />
      </Row>
      <Row>
        <Input type="text"
               name="name"
               placeholder="Job Name"
               value={@state.form.name}
               bsStyle={@getFieldStyle "name"}
               help={@getFieldErrors "name"}
               onChange={@handleChange} />
      </Row>
      <Row>
        <ChooseInput type="type"
                     value={@state.form.type}
                     bsStyle={@getFieldStyle "type"}
                     help={@getFieldErrors "type"}
                     onChange={@handleChange} />
      </Row>
    </Form>
