ComponentView = require "views/component"
Choices = require "models/choices"
# _ = require "underscore"

module.exports = class ComponentFormView extends ComponentView
  events:
    "change .field": "refresh"

  initialize: (opts) ->
    @template = require "templates/component.form"
    super opts

    @className = "#{@routeType} #{@routeType}-form #{@routeType}-form-item"
    @setName()
    _.bindAll @, "refresh"

    null

  refresh: (event) =>
    target = $ event.currentTarget

    name = target.attr "name"
    @model.set name, target.val()
    field = @model.getField name

    console.log "View changed", target.attr "name", target.val()
    $(".#{@routeType}.cost").text @model.collection.calculate().toFixed 2

    null unless field?optionsType? and field.fieldType is "hidden"

    selectedOption = target.select2 "data"
    choicesOptions = Choices.get field.optionsType
    optionFound = _.some choicesOptions, (item) ->
      item.id is selectedOption.id and item.text is selectedOption.text

    unless optionFound
      choicesOptions.push
        id: selectedOption.id
        text: selectedOption.text

    null
