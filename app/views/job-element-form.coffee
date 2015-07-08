ComponentView = require "views/component"
CollectionListView = require "views/collection-list"
Choices = require "models/choices"
# _ = require "underscore"

module.exports = class JobElementFormView extends ComponentView
  tagName: "article"

  events:
    "change .field": "refresh"

  initialize: (opts) ->
    @step = opts.step if opts.step?
    @title = opts.title if opts.title?
    @_children = []

    super opts

    @id = "job-form-#{@routeType}"
    @className = "container #{@routeType} #{@routeType}-form"
    @template = require "templates/#{@routeType}.form"


    if @routeType is "save"
      addCollection collection for collection in Choices.get "jobRoutes"

    @setName()
    _.bindAll @, "refresh"

    null

  addCollection: (collection) ->
    data = @model.attributes[collection] ? false
    @_children.push new CollectionListView
      className: "job-list-collection"
      collection: data
      title: collection
      modelType: collection
      routeType: @routeType
    null

  addSelectOption: (field) ->
    @$("input[name=#{field.name}]").select2
      width: "resolve"
      data: field.options
      createSearchChoice: (term) ->
        optionFound = _.some field.options, (item) ->
          item.text is term

        null if optionFound
        {
          id: "#{field.options.length+1}"
          text: term
        }

    null

  showField: (field) ->
    @addSelectOption field if field.fieldType is "hidden" and field.options?


  render: =>
    console.log "Rendering #{@routeType} element"

    @$el.empty()

    @$el.html @template
      row: @model.toJSON()
      cid: @model.cid
      routeType: @routeType
      step: @step
      title: @title
      cost: @model.cost.toFixed 2
      fields: @model.getFields @showAll

    @showField field for field in @model.fields when field.show

    @$("#job-profit-margin").keyup (event) =>
      profitMargin = @$(event.currentTarget).val()
      $subtotal = @$ "#job-subtotal"
      subtotalValue = $subtotal.data "original"

      unless isNaN(parseFloat(profitMargin)) and not isFinite profitMargin
        profitMargin /= 100
        subtotalValue = parseFloat subtotalValue
        subtotalValue += subtotalValue * profitMargin
        subtotalValue = subtotalValue.toFixed 2

      $subtotal.val subtotalValue
      null

    _(@_children).each (child) =>
      @$(".job.items").append child.render().$el

    @

  refresh: (event) =>
    target = $ event.currentTarget

    name = target.attr "name"
    @model.set name, target.val()
    field = @model.getField name

    if field?optionsType? and field.fieldType is "hidden"
      selectedOption = target.select2 "data"
      choicesOptions = Choices.get field.optionsType

      optionFound = _.some choicesOptions, (item) ->
        item.id is selectedOption.id and item.text is selectedOption.text

      unless optionFound
        choicesOptions.push
          id: selectedOption.id
          text: selectedOption.text

    console.log "View changed", target.attr("name"), target.val()

    null
