config = require "./config"
phantomcss = require "phantomcss"

setSelectors = (driver, selectors, debug = false) ->
  evaluation = (items) ->
    setSelector = (item) ->
      target = "[name='#{item.name}']"
      target = "#{item.parent} #{target}" if item.parent
      $(target).select2 "data", item.value, true
      current = $(target).select2 "data"
      return "Set #{item.name} to #{item.value.text}" if current.text is item.value.text

    response = []
    response.push setSelector item for item in items
    response

  values = driver.evaluate evaluation, selectors, false
  driver.echo value, "PARAMETER" for value in values when debug
  true

expectedJob =
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

describe "Create Estimate", ->
  before ->
    casper.start config.url, ->
      @waitForSelector "section#home", ->
        @click "a.create-link:nth-child(1)"

  it "Should start with the job info page", ->
    casper.then ->
      @waitForSelector "section#create", ->
        "section#create".should.be.inDOM
        "section#create .header-title .header-text".should.have.text /\s+Job Builder\s+/
        phantomcss.screenshot "section#create > .navbar", "add-navbar"
        phantomcss.screenshot "#job-form-create", "add-form"

  it "Should submit the job info form", ->
    formTarget = "#job-form-create > fieldset"

    casper.then ->
      setSelectors @, [
          parent: formTarget
          name: "group_id"
          value: expectedJob.group
        ,
          parent: formTarget
          name: "job_type"
          value: expectedJob.type
      ]

      @fill formTarget,
        "job_name": expectedJob.name

      @click "#job-form-create button.ccma-navigate.next"

  it "Should transition to the concrete component page", ->
    casper.then ->
      @waitForSelector "section#concrete", ->
        "section#concrete".should.be.inDOM
        "section#concrete .header-job-name h3".should.have.text expectedJob.name
        "section#concrete .header-title .header-text".should.have.text /concrete/i
        phantomcss.screenshot "section#concrete > .navbar", "concrete-navbar"
        phantomcss.screenshot "#job-form-concrete", "concrete-form"

  it "Should add a sidewalk", ->
    formTarget = "#job-form-concrete fieldset"

    casper.then ->
      setSelectors @, [
          parent: formTarget
          name: "concrete_type"
          value: expectedJob.concreteA.type
        ,
          parent: formTarget
          name: "length_units"
          value: expectedJob.concreteA.lengthUnits
        ,
          parent: formTarget
          name: "width_units"
          value: expectedJob.concreteA.widthUnits
        ,
          parent: formTarget
          name: "depth_units"
          value: expectedJob.concreteA.depthUnits
        ,
          parent: formTarget
          name: "price_units"
          value: expectedJob.concreteA.priceUnits
      ]

      @fillSelectors formTarget,
        "[name='quantity']": expectedJob.concreteA.quantity
        "[name='length']": expectedJob.concreteA.length
        "[name='width']": expectedJob.concreteA.width
        "[name='depth']": expectedJob.concreteA.depth
        "[name='price']": expectedJob.concreteA.price
        "[name='tax']": expectedJob.concreteA.tax

      "#job-form-concrete .concrete.cost".should.have.text "#{expectedJob.concreteA.cost}"

      @click "#job-form-concrete button.concrete.add"

  it "Should add a second concrete component item", ->
    target = "#job-form-concrete .concrete-form-item:nth-child(2)"
    casper.then ->
      @waitForSelector target, ->
        target.should.be.inDOM

  it "Should add a sculpture", ->
    formTarget = "#job-form-concrete .concrete-form-item:nth-child(2) fieldset"

    casper.then ->
      setSelectors @, [
          parent: formTarget
          name: "concrete_type"
          value: expectedJob.concreteB.type
        ,
          parent: formTarget
          name: "length_units"
          value: expectedJob.concreteB.lengthUnits
        ,
          parent: formTarget
          name: "width_units"
          value: expectedJob.concreteB.widthUnits
        ,
          parent: formTarget
          name: "depth_units"
          value: expectedJob.concreteB.depthUnits
        ,
          parent: formTarget
          name: "price_units"
          value: expectedJob.concreteB.priceUnits
      ]

      @fillSelectors formTarget,
        "[name='quantity']": expectedJob.concreteB.quantity
        "[name='length']": expectedJob.concreteB.length
        "[name='width']": expectedJob.concreteB.width
        "[name='depth']": expectedJob.concreteB.depth
        "[name='price']": expectedJob.concreteB.price
        "[name='tax']": expectedJob.concreteB.tax

      "#job-form-concrete .concrete.cost".should.have.text "#{expectedJob.concreteB.cost}"

      @click "#job-form-concrete button.ccma-navigate.next"

  it "Should transition to the labor component page", ->
    casper.then ->
      @waitForSelector "section#labor", ->
        "section#labor".should.be.inDOM
        "section#labor .header-job-name h3".should.have.text expectedJob.name
        "section#labor .header-title .header-text".should.have.text /labor/i
        phantomcss.screenshot "section#labor > .navbar", "labor-navbar"
        phantomcss.screenshot "#job-form-labor", "labor-form"

  it "Should add a driver", ->
    formTarget = "#job-form-labor fieldset"

    casper.then ->
      setSelectors @, [
          parent: formTarget
          name: "labor_type"
          value: expectedJob.laborA.type
        ,
          parent: formTarget
          name: "labor_time_units"
          value: expectedJob.laborA.timeUnits
        ,
          parent: formTarget
          name: "rate_units"
          value: expectedJob.laborA.rateUnits
      ]

      @fillSelectors formTarget,
        "[name='laborers_count']": expectedJob.laborA.quantity
        "[name='labor_time']": expectedJob.laborA.time
        "[name='rate']": expectedJob.laborA.rate

      "#job-form-labor .labor.cost".should.have.text "#{expectedJob.laborA.cost}"

      @click "#job-form-labor button.labor.add"

  it "Should add a second labor component item", ->
    target = "#job-form-labor .labor-form-item:nth-child(2)"
    casper.then ->
      @waitForSelector target, ->
        target.should.be.inDOM

  it "Should add a tester", ->
    formTarget = "#job-form-labor .labor-form-item:nth-child(2) fieldset"

    casper.then ->
      setSelectors @, [
          parent: formTarget
          name: "labor_type"
          value: expectedJob.laborB.type
        ,
          parent: formTarget
          name: "labor_time_units"
          value: expectedJob.laborB.timeUnits
        ,
          parent: formTarget
          name: "rate_units"
          value: expectedJob.laborB.rateUnits
      ]

      @fillSelectors formTarget,
        "[name='laborers_count']": expectedJob.laborB.quantity
        "[name='labor_time']": expectedJob.laborB.time
        "[name='rate']": expectedJob.laborB.rate

      "#job-form-labor .labor.cost".should.have.text "#{expectedJob.laborB.cost}"

      @click "#job-form-labor button.ccma-navigate.next"

  it "Should transition to the material component page", ->
    casper.then ->
      @waitForSelector "section#materials", ->
        "section#materials".should.be.inDOM
        "section#materials .header-job-name h3".should.have.text expectedJob.name
        "section#materials .header-title .header-text".should.have.text /materials/i
        phantomcss.screenshot "section#materials > .navbar", "material-navbar"
        phantomcss.screenshot "#job-form-materials", "material-form"

  it "Should add wires", ->
    formTarget = "#job-form-materials fieldset"

    casper.then ->
      setSelectors @, [
        {
          parent: formTarget
          name: "material_type"
          value: expectedJob.materialA.type
        }
      ]

      @fillSelectors formTarget,
        "[name='quantity']": expectedJob.materialA.quantity
        "[name='price']": expectedJob.materialA.price
        "[name='tax']": expectedJob.materialA.tax

      "#job-form-materials .materials.cost".should.have.text "#{expectedJob.materialA.cost}"

      @click "#job-form-materials button.materials.add"

  it "Should add a second material component item", ->
    target = "#job-form-materials .materials-form-item:nth-child(2)"
    casper.then ->
      @waitForSelector target, ->
        target.should.be.inDOM

  it "Should add adamantium", ->
    formTarget = "#job-form-materials .materials-form-item:nth-child(2) fieldset"

    casper.then ->
      setSelectors @, [
        {
          parent: formTarget
          name: "material_type"
          value: expectedJob.materialB.type
        }
      ]

      @fillSelectors formTarget,
        "[name='quantity']": expectedJob.materialB.quantity
        "[name='price']": expectedJob.materialB.price
        "[name='tax']": expectedJob.materialB.tax

      "#job-form-materials .materials.cost".should.have.text "#{expectedJob.materialB.cost}"

      @click "#job-form-materials button.materials.add"

  it "Should add a third material component item", ->
    target = "#job-form-materials .materials-form-item:nth-child(3)"
    casper.then ->
      @waitForSelector target, ->
        target.should.be.inDOM

  it "Should add caps", ->
    formTarget = "#job-form-materials .materials-form-item:nth-child(3) fieldset"

    casper.then ->
      setSelectors @, [
        {
          parent: formTarget
          name: "material_type"
          value: expectedJob.materialC.type
        }
      ]

      @fillSelectors formTarget,
        "[name='quantity']": expectedJob.materialC.quantity
        "[name='price']": expectedJob.materialC.price
        "[name='tax']": expectedJob.materialC.tax

      "#job-form-materials .materials.cost".should.have.text "#{expectedJob.materialC.cost}"

      @click "#job-form-materials button.ccma-navigate.next"

  it "Should transition to the equipment component page", ->
    casper.then ->
      @waitForSelector "section#equipment", ->
        "section#equipment".should.be.inDOM
        "section#equipment .header-job-name h3".should.have.text expectedJob.name
        "section#equipment .header-title .header-text".should.have.text /equipment/i
        phantomcss.screenshot "section#equipment > .navbar", "equipment-navbar"
        phantomcss.screenshot "#job-form-equipment", "equipment-form"

  it "Should add bobcat", ->
    formTarget = "#job-form-equipment fieldset"

    casper.then ->
      setSelectors @, [
          parent: formTarget
          name: "equipment_type"
          value: expectedJob.equipment.type
        ,
          parent: formTarget
          name: "rate_units"
          value: expectedJob.equipment.rateUnits
      ]

      @fillSelectors formTarget,
        "[name='quantity']": expectedJob.equipment.quantity
        "[name='equipment_time']": expectedJob.equipment.time
        "[name='rate']": expectedJob.equipment.rate

      "#job-form-equipment .equipment.cost".should.have.text "#{expectedJob.equipment.cost}"

      @click "#job-form-equipment button.ccma-navigate.next"

  it "Should transition to the subcontractor component page", ->
    casper.then ->
      @waitForSelector "section#subcontractor", ->
        "section#subcontractor".should.be.inDOM
        "section#subcontractor .header-job-name h3".should.have.text expectedJob.name
        "section#subcontractor .header-title .header-text".should.have.text /subcontractor/i
        phantomcss.screenshot "section#subcontractor > .navbar", "subcontractor-navbar"
        phantomcss.screenshot "#job-form-subcontractor", "subcontractor-form"

  it "Should add subcontractor", ->
    formTarget = "#job-form-subcontractor fieldset"

    casper.then ->
      @fillSelectors formTarget,
        "[name='scope_of_work']": expectedJob.subcontractor.scope
        "[name='contractor_amount']": expectedJob.subcontractor.cost

      "#job-form-subcontractor .subcontractor.cost".should.have.text "#{expectedJob.subcontractor.cost}"

      @click "#job-form-subcontractor button.ccma-navigate.next"

  it "Should transition to the job save page", ->
    casper.then ->
      @waitForSelector "section#save", ->
        "section#save".should.be.inDOM
        "section#save .header-job-name h3".should.have.text expectedJob.name
        "section#save .header-title .header-text".should.have.text /job builder/i
        phantomcss.screenshot "section#save > .navbar", "save-navbar"
        phantomcss.screenshot "#job-form-save fieldset", "save-form"
        phantomcss.screenshot "#job-accordion", "save-accordion"

        @click "#job-list-concrete .panel-heading-link"
        phantomcss.screenshot "#job-list-concrete", "save-concrete"

        @click "#job-list-labor .panel-heading-link"
        phantomcss.screenshot "#job-list-labor", "save-labor"

        @click "#job-list-materials .panel-heading-link"
        phantomcss.screenshot "#job-list-materials", "save-materials"

        @click "#job-list-equipment .panel-heading-link"
        phantomcss.screenshot "#job-list-equipment", "save-equipment"

        @click "#job-list-subcontractor .panel-heading-link"
        phantomcss.screenshot "#job-list-subcontractor", "save-subcontractor"

  it "Should set a profit margin", ->
    formTarget = "#job-form-save fieldset"

    casper.then ->
      @fillSelectors formTarget,
        "[name='profit_margin']": expectedJob.profitMargin

    casper.thenEvaulate () ->
      $("#job-form-save fieldset [name='profit_margin']").keyup()
      true

    casper.then ->
      "subtotal".should.have.fieldValue "#{expectedJob.cost}"

      @click "#job-form-subcontractor button.job.save"
