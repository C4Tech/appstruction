module.exports =
  tax: (total, tax = 0) ->
    tax /= 100
    tax = 0.0 if isNaN tax
    taxCost = total * tax
    +taxCost.toFixed 2

  calculate: (total, tax = 0) ->
    total /= 1
    total = 0.00 if isNaN total
    total = +total.toFixed 2
    total + @tax total, tax
