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
    item[name] = event.target.value
    JobActions.updateComponent @typeName, @handleRecalculate item

    null

  handleRecalculate: (item) ->
    return @recalculate item if @recalculate?
    item
