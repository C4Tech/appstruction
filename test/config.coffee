require "./"
phantomcss = require "phantomcss"

phantomcss.init
  prefixCount: true

casper.on "remote.message", (message) ->
  @echo "#{message}", "COMMENT"

module.exports =
  url: "http://localhost:8080/devel.html"
  navbarSelector: "header > .navbar"
  jobTitleSelector: "article header h2"
  jobPageTitleSelector: "article header h4"

  fillSelectize: (formTarget, key, value, exists = false) ->
    selectBox = ".Select.#{key}"
    selectInput = "#{selectBox} .Select-input > input"
    selectMenu = "#{selectBox} > .Select-menu-outer > .Select-menu"
    selectOption = "#{selectMenu} > .Select-option"
    selectOption = ":nth-child(2)" if exists

    casper.thenClick selectBox, ->
      @echo @getHTML selectBox, true

    casper.waitForSelector selectMenu, ->
      selector = {}
      selector[selectInput] = value
      @fillSelectors formTarget, selector

    casper.waitForSelectorTextChange selectOption, ->
      selectOption.should.have.text value
      @click selectOption

    null

  fillSelectizeOld: (formTarget, key, value) ->
    casper.thenClick ".Select.#{key}"
    casper.then ->
      phantomcss.screenshot ".Select.#{key}", "job-type-selector"
      @clickLabel value

    null

  clickNext: (formTarget) ->
    casper.thenClick "#{formTarget} footer button.btn-success"

    null

  job:
    group: "Test Group"
    name: "Job Testing"
    type: "Commercial"
    profitMargin: 6.2
    cost: 1798.94
    concreteA:
      type: "Sidewalk"
      quantity: 3
      length: 1
      lengthUnits: "Yards"
      width: 3
      widthUnits: "Feet"
      depth: 36
      depthUnits: "Inches"
      price: 10
      priceUnits: "Per Cubic Yard"
      tax: 0.1
      cost: 30.03
    concreteB:
      type: "Sculpture"
      quantity: 1
      length: 3
      lengthUnits: "Yards"
      width: 1
      widthUnits: "Yards"
      depth: 2
      depthUnits: "Yards"
      price: 5
      priceUnits: "Per Cubic Yard"
      tax: 0.0
      cost: 60.03
    laborA:
      type: "Driver"
      quantity: 1
      time: 3
      timeUnits: "Hours"
      rate: 50
      rateUnits: "Days"
      cost: 18.75
    laborB:
      type: "Tester"
      quantity: 3
      time: 1
      timeUnits: "Days"
      rate: 10
      rateUnits: "Hours"
      cost: 258.75
    materialA:
      type: "Wire (sheet)"
      quantity: 10
      price: 5
      tax: "0.0"
      cost: "50.00"
    materialB:
      type: "Adamantium"
      quantity: 212
      price: 5
      tax: "0.0"
      cost: "1110.00"
    materialC:
      type: "Cap (lf)"
      quantity: 1
      price: 20
      tax: 10.0
      cost: "1132.00"
    equipment:
      type: "Bobcat"
      quantity: 2
      time: 3
      rate: 20
      rateUnits: "Daily"
      cost: "120.00"
    subcontractor:
      scope: "Quality Tester"
      cost: "123.14"
