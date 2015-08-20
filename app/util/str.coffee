module.exports =
  concrete: "Describe each concrete structure to be built"
  material: "Describe all the material needed on the job"
  equipment: "List all equipment"
  dropdown: "If you don't see the option you want in the
             dropdown, start typing and it will be available
             in the future."

  dashToCamel: (input) ->
    input.toLowerCase().replace /-(.)/g, (match, group) ->
      group?.toUpperCase()
