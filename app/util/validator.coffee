module.exports =
  run: (attrs, fields) ->
    fail = @checkField field, attrs[field.name], fail for field in fields
    fail = "" unless fail
    fail

  checkField: (field, value, fail = false) ->
    fail if fail

    required = field.required ? true
    label = field.label ? field.placeholder

    fail = switch field.fieldType
      when "number", "text", "select"
        @[field.fieldType] value, label, required
      else false

    fail

  isRequired: (value, label) ->
    result = false
    result = "You must enter a #{label}" unless value?
    result = "You must enter a #{label}" if value is ""
    result

  number: (value, label, required) ->
    label = "#{label}"
    result = false

    result = @isRequired value, label if required

    if value?
      result = "#{label} must be a number" if isNaN value
      result = "#{label} must be a number" if isNaN parseInt value
      result = "#{label} must be at least 0" if value < 0
    result

  text: (value, label, required) ->
    result = false
    result = @isRequired value, label if required
    result

  select: (value, label, required) ->
    result = false
    result = @isRequired value, label if required

    if value?
      result = "You must select a #{label}" if value < 0
    result
