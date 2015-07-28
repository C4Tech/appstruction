module.exports =
  tax: (total, tax = 0) ->
    tax = tax / 100
    taxCost = total * tax
    taxCost.toFixed 2

  calculate: (total, tax = 0) ->
    total = total.toFixed 2
    total + @tax total, tax
