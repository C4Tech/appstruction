config = require "./config"
phantomcss = require "phantomcss"

expectedJob = config.job
fillSelectize = config.fillSelectize
clickNext = config.clickNext
navbarSelector = config.navbarSelector
jobTitleSelector = config.jobTitleSelector
jobPageTitleSelector = config.jobPageTitleSelector

describe "Create Estimate", ->
  before ->
    casper.start config.url, ->
      @waitForSelector "article#home", ->
        @click "a.btn-main-nav:nth-child(1)"


  describe "Job Info Form", ->
    formTarget = "form#create"

    it "Should transition to the job info page", ->
      casper.waitForSelector formTarget, ->
        formTarget.should.be.inDOM
        jobTitleSelector.should.have.text /Job Builder/
        phantomcss.screenshot navbarSelector, "add-navbar"
        phantomcss.screenshot formTarget, "add-form"

    it "Should submit the job info form", ->
      fillSelectize formTarget, "group-name", expectedJob.group

      casper.then ->
        @fill formTarget,
          "name": expectedJob.name

      fillSelectize formTarget, "job-type", expectedJob.type

      clickNext formTarget

  return describe "Concrete Component Form", ->
    formTarget = "form#concrete"

    return it "Should transition to the concrete component page", ->
      casper.waitForSelector formTarget, ->
          formTarget.should.be.inDOM
          jobTitleSelector.should.have.text expectedJob.name
          jobPageTitleSelector.should.have.text /concrete/i
          phantomcss.screenshot navbarSelector, "concrete-navbar"
          phantomcss.screenshot formTarget, "concrete-form"

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

  describe "Labor Component Form", ->
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

  describe "Material Component Form", ->
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

  describe "Equipment Component Form", ->
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

  describe "Subcontractor Component Form", ->
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

  describe "Job Save Form", ->
    it "Should transition to the job save page", ->
      casper.then ->
        @waitForSelector "section#save", ->
          "section#save".should.be.inDOM
          "section#save .header-job-name h3".should.have.text expectedJob.name
          "section#save .header-title .header-text".should.have.text /job builder/i
          phantomcss.screenshot "section#save > .navbar", "save-navbar"
          phantomcss.screenshot "#job-form-save fieldset", "save-form"
          phantomcss.screenshot "#job-accordion", "save-accordion"

    it "Should open job info accordions", ->
      casper.then ->
        @waitForSelector "#job-accordion", ->
          @click "#job-list-concrete .panel-heading-link"
          @wait 1000
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

        @evaluate ->
          $("#job-form-save fieldset [name='profit_margin']").keyup()

        "subtotal".should.have.fieldValue "#{expectedJob.cost}"

        @click "#job-form-subcontractor button.job.save"
