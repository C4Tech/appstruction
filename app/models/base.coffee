Choices = require "models/choices"
# _ = require "underscore"
# Backbone = require "backbone"

module.exports = class BaseModel extends Backbone.Model
  fields: []
  cost: 0
  index: 0

  check:
    required: (value, label) ->
      result = false
      result = "You must enter a #{label}" unless value?
      result = "You must enter a #{label}" if value is ""
      result

    number: (value, label, required) ->
      # add double quotes around label
      label = "\"#{label}\""
      result = false

      result = @check.required value, label if required

      if value?
        result = "#{label} must be a number" if isNaN value
        result = "#{label} must be a number" if isNaN parseInt value
        result = "#{label} must be at least 0" if value < 0
      result

    text: (value, label, required) ->
      result = false
      result = @check.required value, label if required
      result

    select: (value, label, required) ->
      result = false
      result = @check.required value, label if required

      if value?
        result = "You must select a #{label}" if value < 0
      result

  initialize: ->
    _(@fields).each (field) ->
      field.displayLabel = field.label ? field.placeholder
      field.options = Choices.get field.optionsType

  validate: (attrs, opts) ->
    fail = false
    for field in @fields
      required = field.required ? true
      label = field.label ? field.placeholder
      do (field) =>
        unless fail
          fail = switch field.fieldType
            when "number", "text", "select"
              @check[field.fieldType] attrs[field.name], label, required
            else false
        null
    fail = "" unless fail
    fail

  getField: (name) ->
    found = _.where @fields, {name: name}
    found[0] ? null

  getFields: (showAll = false) ->
    fields = if showAll then @fields else _.where @fields, show: true
    field.value = @getValue field for field in fields
    fields

  getValue: (field) =>
    value = @attributes[field.name]
    console.log "Field is #{field.name} with value of #{value}"

    if field.options?
      value = @_setValue item, value for item in field.options

    value

  _setValue: (item, value) ->
    value = if parseInt(item.id) is parseInt(value) then item.text else value
    value

  numberValid: (numbers...) ->
    false for number in numbers when number is 0 or isNaN number
    true

  round: (number) ->
    Math.round(number * 100) / 100
