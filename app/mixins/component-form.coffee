ChoiceActions = require "choices/actions"
JobActions = require "jobs/actions"
Str = require "util/str"

module.exports =
  handleChange: (event) ->
    item = @props.item
    name = Str.dashToCamel event.target.name
    @onChangeFormField name, event.target.value

  handleSelect: (field) ->
    (value) =>
      @onChangeFormField field, value

  handleSelectCreate: (field) ->
    (value) =>
      key = value.toLowerCase()
      ChoiceActions.create field, value, key
      @onChangeFormField field, key

  onChangeFormField: (key, value) ->
    return @changeFormField key, value if @changeFormField?
    @defaultChangeFormField key, value

  defaultChangeFormField: (key, value) ->
    item = @props.item
    item[key] = value
    JobActions.upsertComponent @typeName, @handleRecalculate item

  handleRecalculate: (item) ->
    return @recalculate item if @recalculate?
    item
