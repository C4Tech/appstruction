module.exports =
  dashToCamel: (input) ->
    input.toLowerCase().replace /-(.)/g, (match, group) ->
      group?.toUpperCase()
