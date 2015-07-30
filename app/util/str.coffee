module.exports =
  dashToCamel: (input) ->
    input.toLowerCase().replace /-(.)/g, (match, group) ->
      console.log "#{match} and #{group}"
      group?.toUpperCase()
