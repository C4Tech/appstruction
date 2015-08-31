
module.exports = class LabelLookup
  getById: (key, value) ->
    options = @options ? @getState().options
    return item for item in options[key] when item.value is value

  getLabelFor: (type, value, quantity = 1, inclusive = false) ->
    choice = @getById type, value
    return value unless choice
    pluralize choice.label, +quantity, inclusive
