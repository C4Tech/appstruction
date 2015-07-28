module.exports = class LabelLookup
  getById: (key, value) ->
    return choice for choice in @options[key]? when choice.value is value

  getLabelFor: (type, value, quantity = 1, inclusive = false) ->
    choice = @getById type, value
    return value unless choice
    pluralize choice.label, quantity, inclusive
