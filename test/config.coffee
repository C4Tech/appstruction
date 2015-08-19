require "./"
phantomcss = require "phantomcss"

phantomcss.init
  prefixCount: true

# casper.on "remote.message", (message) ->
  # @echo "#{message}", "COMMENT"

module.exports =
  url: "http://localhost:8080/devel.html"
  navbarSelector: "header > .navbar"
  jobTitleSelector: "article header h2"
  jobPageTitleSelector: "article header h4"

  checkPage: (page, target, title, navbar = true) ->
    navbarSelector = @navbarSelector
    casper.waitForSelector target, ->
      target.should.be.inDOM
      "article header h2".should.have.text title
      phantomcss.screenshot navbarSelector, "#{page}-navbar" if navbar
      phantomcss.screenshot target, "#{page}-form"

  checkFormPage: (page, target, title, navbar = true) ->
    jobName = @job.name
    navbarSelector = @navbarSelector
    casper.waitForSelector target, ->
      target.should.be.inDOM
      "article header h2".should.have.text jobName
      "article header h4".should.have.text title
      phantomcss.screenshot navbarSelector, "#{page}-navbar" if navbar
      phantomcss.screenshot target, "#{page}-form"

  checkAdditionalFormRow: (page, target, counter = 2) ->
    casper.waitForSelector target, ->
      target.should.be.inDOM

  fillSelectize: (formTarget, key, value, dynamic = true) ->
    selectBox = "#{formTarget} .Select.#{key}"
    selectInput = "#{selectBox} .Select-input > input"
    selectOption = "#{selectBox} .Select-menu .Select-option"

    casper.thenClick selectBox, ->
      @sendKeys selectInput, value, {keepFocus: true}

    if dynamic
      casper.waitForSelectorTextChange selectOption, ->
        @sendKeys selectInput, @page.event.key.Enter
        @click formTarget
    else
      casper.then ->
        @sendKeys selectInput, @page.event.key.Enter
        @click formTarget

    null

  fillInput: (formTarget, input, value) ->
    casper.then ->
      @sendKeys "#{formTarget} input[name='#{input}']", value

    null

  clickAdd: (formTarget) ->
    casper.thenClick "#{formTarget} div.row .btn-warning"

    null

  clickNext: (formTarget) ->
    casper.thenClick "#{formTarget} footer .btn-success"

    null

  checkComponentCost:(formTarget, cost) ->
    casper.then ->
      "#{formTarget} .component-cost".should.have.text cost

    null

  job:
    group: "Test Group"
    name: "Job Testing"
    type: "Commercial"
    profitMargin: "6.2"
    cost: "1798.94"
    concreteA:
      type: "Sidewalk"
      quantity: "3"
      length: "1"
      lengthUnits: "Yards"
      width: "3"
      widthUnits: "Feet"
      depth: "36"
      depthUnits: "Inches"
      price: "10"
      priceUnits: "Cubic Yard"
      tax: "0.1"
      cost: "30.03"
    concreteB:
      type: "Sculpture"
      quantity: "1"
      length: "3"
      lengthUnits: "Yards"
      width: "1"
      widthUnits: "Yards"
      depth: "2"
      depthUnits: "Yards"
      price: "5"
      priceUnits: "Cubic Yard"
      tax: "0.0"
      cost: "60.03"
    laborA:
      type: "Driver"
      quantity: "1"
      time: "3"
      timeUnits: "Hours"
      price: "50"
      priceUnits: "Daily"
      cost: "18.75"
    laborB:
      type: "Tester"
      quantity: "3"
      time: "1"
      timeUnits: "Days"
      price: "10"
      priceUnits: "Hourly"
      cost: "258.75"
    materialA:
      type: "Wire (sheet)"
      quantity: "10"
      price: "5"
      tax: "0.0"
      cost: "50"
    materialB:
      type: "Adamantium"
      quantity: "212"
      price: "5"
      tax: "0.0"
      cost: "1110"
    materialC:
      type: "Cap (lf)"
      quantity: "1"
      price: "20"
      tax: "10.0"
      cost: "1132"
    equipment:
      type: "Bobcat"
      quantity: "2"
      time: "3"
      timeUnits: "Days"
      price: "20"
      priceUnits: "Daily"
      cost: "120"
    subcontractor:
      scope: "Quality Tester"
      cost: "123.14"
