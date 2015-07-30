JobActions = require "jobs/actions"
Str = require "util/str"

module.exports =
  handleChange: (event) ->
    item = @props.item
    name = Str.dashToCamel event.target.name
    @changeFormField name, event.target.value

  handleSelect: (field) ->
    (value) =>
      @changeFormField field, value

  changeFormField: (key, value) ->
    item = @props.item
    item[key] = value
    JobActions.updateComponent @typeName, @handleRecalculate item

  handleRecalculate: (item) ->
    return @recalculate item if @recalculate?
    item
