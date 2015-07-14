module.exports =
  getInitialState: ->
    {
      errors: {}
    }

  getDefaultProps: ->
    {
      hideAfterSuccess: true
    }

  getFieldStyle: (field) ->
    "error" if @state.errors[field]?.length

  getFieldErrors: (field, glue = ". ") ->
    @state.errors[field].join glue if @state.errors[field]?.length

  onHandleSubmit: (event) ->
    event.preventDefault()

    if @handleSubmit?
      @handleSubmit event
    else
      @defaultSubmitHandler event

    null

  defaultSubmitHandler: (event) ->
    formData = @onGetFormData()
    return unless @onValidate formData

    @onPerformSubmit formData
    null

  onPerformSubmit: (formData) ->
    if @performSubmit?
      @performSubmit formData
    else
      @defaultPerformSubmit formData
    null

  defaultPerformSubmit: (formData) ->
    if @props.item?
      resId = @props.item.id
      @actions.edit resId, formData, @onHandleSuccess, @onHandleFailure
    else
      @actions.add formData, @onHandleSuccess, @onHandleFailure

    null

  onGetFormData: ->
    response = {}
    response = @getFormData() if @getFormData?
    response

  onValidate: (data) ->
    errors = {}
    errors = @validate data if @validate?

    @setState
      errors: errors

    isValid = true
    isValid = false for name, error of errors when error.length
    isValid

  onHandleSuccess: (data) ->
    return unless data.success
    @onHideAfterSuccess() if @props.hideAfterSuccess
    @handleSuccess data if @handleSuccess?
    null

  onHandleFailure:  (xhr) ->
    errors = xhr.responseJSON?.data or xhr.responseJSON
    @setState {errors: errors} if errors?
    @handleFailure() if @handleFailure?
    null

  onHideAfterSuccess: ->
    @props.onRequestHide?()
    null
