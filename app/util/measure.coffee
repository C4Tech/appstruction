# Qty = require "js-quantities"

module.exports =
  defaultUnit: "ft"

  normalize: (measure = 0, unit = @defaultUnit, toUnit = @defaultUnit) ->
    Qty("#{measure} #{unit}").to toUnit
