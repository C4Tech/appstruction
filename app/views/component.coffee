BaseView = require "views/base"
# _ = require "underscore"

module.exports = class ComponentView extends BaseView
  # Our constructor
  initialize: (opts) ->
    @routeType = opts.routeType if opts.routeType?
    @showAll ?= false
    @templateFile ?= "templates/component.list"
    @className ?= @routeType

    @setName()

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

  showField: (field) ->
    @addSelectOption field if field.fieldType is "hidden" and field.options?

  render: ->
    @$el.html @template
      row: @model.toJSON()
      routeType: @routeType
      cid: @model.cid
      cost: @model.calculate?()
      fields: @model.getFields @showAll
      index: @model.index

    @showField field for field in @model.fields when field.show

    @
