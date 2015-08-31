# Qty = require "js-quantities"
LabelLookup = require "util/label-lookup"

class MeasureUtil extends LabelLookup
  defaultUnit: "ft"

  options:
    linear: [
        value: "in"
        label: "Inches"
      ,
        value: "ft"
        label: "Feet"
      ,
        value: "yd"
        label: "Yards"
      ,
        value: "cm"
        label: "Centimeters"
      ,
        value: "m"
        label: "Meters"
    ]

    volume: [
        value: "in"
        label: "Cubic Inch"
      ,
        value: "ft"
        label: "Cubic Foot"
      ,
        value: "yd"
        label: "Cubic Yard"
      ,
        value: "cm"
        label: "Cubic Centimeter"
      ,
        value: "m"
        label: "Cubic Meter"
    ]

  setDefault: (@defaultUnit = "ft") ->
    null

  normalize: (measure = 0, unit = @defaultUnit, toUnit = @defaultUnit) ->
    Qty("#{measure} #{unit}").to toUnit

module.exports = new MeasureUtil
