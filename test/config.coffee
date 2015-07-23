phantomcss = require "phantomcss"

phantomcss.init
  prefixCount: true

# casper.on "remote.message", (message) ->
#   @echo "#{message}", "COMMENT"

casper.on "remote.alert", (message) ->
  @echo "ALERT: #{message}", "WARNING"


module.exports =
  url: "http://localhost:8080/devel.html"
  job:
    group:
      id: "1"
      text: "Test Group"
    name: "Job Testing"
    profitMargin: 6.2
    cost: 1798.94
    type:
      id: "2"
      text: "Commercial"
    concreteA:
      type:
        id: "1"
        text: "Sidewalk"
      quantity: 3
      length: 1
      lengthUnits:
        id: "yd"
        text: "Yards"
      width: 3
      widthUnits:
        id: "ft"
        text: "Feet"
      depth: 36
      depthUnits:
        id: "in"
        text: "Inches"
      price: 10
      priceUnits:
        id: "yd"
        text: "Per Cubic Yard"
      tax: 0.1
      cost: 30.03
    concreteB:
      type:
        id: "7"
        text: "Sculpture"
      quantity: 1
      length: 3
      lengthUnits:
        id: "yd"
        text: "Yards"
      width: 1
      widthUnits:
        id: "yd"
        text: "Yards"
      depth: 2
      depthUnits:
        id: "yd"
        text: "Yards"
      price: 5
      priceUnits:
        id: "yd"
        text: "Per Cubic Yard"
      tax: 0.0
      cost: 60.03
    laborA:
      type:
        id: "5"
        text: "Driver"
      quantity: 1
      time: 3
      timeUnits:
        id: "hour"
        text: "Hours"
      rate: 50
      rateUnits:
        id: "day"
        text: "Days"
      cost: 18.75
    laborB:
      type:
        id: "9"
        text: "Tester"
      quantity: 3
      time: 1
      timeUnits:
        id: "day"
        text: "Days"
      rate: 10
      rateUnits:
        id: "hour"
        text: "Hours"
      cost: 258.75
    materialA:
      type:
        id: "1"
        text: "Wire (sheet)"
      quantity: 10
      price: 5
      tax: "0.0"
      cost: "50.00"
    materialB:
      type:
        id: "7"
        text: "Adamantium"
      quantity: 212
      price: 5
      tax: "0.0"
      cost: "1110.00"
    materialC:
      type:
        id: "4"
        text: "Cap (lf)"
      quantity: 1
      price: 20
      tax: 10.0
      cost: "1132.00"
    equipment:
      type:
        id: "3"
        text: "Bobcat"
      quantity: 2
      time: 3
      rate: 20
      rateUnits:
        id: "day"
        text: "Daily"
      cost: "120.00"
    subcontractor:
      scope: "Quality Tester"
      cost: "123.14"
