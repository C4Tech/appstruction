Choices = require "models/choices"
validator = require "util/validator"
# _ = require "underscore"
# Backbone = require "backbone"

module.exports = class BaseModel extends Backbone.Model
  fields: []
  cost: 0
  index: 0

  initialize: ->
    _(@fields).each (field) ->
      field.displayLabel = field.label ? field.placeholder
      field.options = Choices.get field.optionsType

  validate: (attrs, opts) ->
    validator.run attrs, @fields

  getField: (name) ->
    found = _.where @fields, {name: name}
    found[0] ? null

  getFields: (showAll = false) ->
    fields = if showAll then @fields else _.where @fields, show: true
    field.value = @getValue field for field in fields
    fields

  getValue: (field) =>
    value = @attributes[field.name]
    log.trace "Field is #{field.name} with value of #{value}"

    if field.options?
      value = @setValue item, value for item in field.options

    value

  setValue: (item, value) ->
    value = if parseInt(item.id) is parseInt(value) then item.text else value
    value

  numberValid: (numbers...) ->
    false for number in numbers when number is 0 or isNaN number
    true

  round: (number) ->
    Math.round(number * 100) / 100
