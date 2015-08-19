config = require "./config"
phantomcss = require "phantomcss"

expectedJob = config.job

describe "Create Estimate", ->
  before ->
    casper.start config.url, ->
      @waitForSelector "article#home", ->
        @click "a.btn-main-nav:nth-child(1)"

  describe "Job Info Form", ->
    formTarget = "form#create"

    it "Should transition to the job info page", ->
      config.checkPage "add", formTarget, /Job Builder/

    it "Should submit the job info form", ->
      config.fillSelectize formTarget, "group-name", expectedJob.group
      config.fillInput formTarget, "name", expectedJob.name
      config.fillSelectize formTarget, "job-type", expectedJob.type
      config.clickNext formTarget

  describe "Concrete Component Form", ->
    formTarget = "form#concrete"
    secondTarget = "#{formTarget} > .item:nth-child(2)"

    it "Should transition to the concrete component page", ->
      config.checkFormPage "concrete", formTarget, /concrete/i

    it "Should add a sidewalk", ->
      concrete = expectedJob.concreteA
      config.fillSelectize formTarget, "concrete-type", concrete.type
      config.fillInput formTarget, "quantity", concrete.quantity
      config.fillInput formTarget, "length", concrete.length
      config.fillSelectize formTarget, "length-units", concrete.lengthUnits
      config.fillInput formTarget, "width", concrete.width
      config.fillSelectize formTarget, "width-units", concrete.widthUnits
      config.fillInput formTarget, "depth", concrete.depth
      config.fillSelectize formTarget, "depth-units", concrete.depthUnits
      config.fillInput formTarget, "price", concrete.price
      config.fillSelectize formTarget, "price-units", concrete.priceUnits
      config.fillInput formTarget, "tax", concrete.tax
      config.checkComponentCost formTarget, concrete.cost

    it "Should add a second concrete component item", ->
      config.clickAdd formTarget
      config.checkAdditionalFormRow "concrete", secondTarget

    it "Should add a sculpture", ->
      concrete = expectedJob.concreteB
      config.fillSelectize secondTarget, "concrete-type", concrete.type
      config.fillInput secondTarget, "quantity", concrete.quantity
      config.fillInput secondTarget, "length", concrete.length
      config.fillSelectize secondTarget, "length-units", concrete.lengthUnits
      config.fillInput secondTarget, "width", concrete.width
      config.fillSelectize secondTarget, "width-units", concrete.widthUnits
      config.fillInput secondTarget, "depth", concrete.depth
      config.fillSelectize secondTarget, "depth-units", concrete.depthUnits
      config.fillInput secondTarget, "price", concrete.price
      config.fillSelectize secondTarget, "price-units", concrete.priceUnits
      config.fillInput secondTarget, "tax", concrete.tax
      config.checkComponentCost formTarget, concrete.cost
      config.clickNext formTarget

  return describe "Labor Component Form", ->
    formTarget = "form#labor"
    secondTarget = "#{formTarget} > .item:nth-child(2)"

    it "Should transition to the labor component page", ->
      config.checkFormPage "labor", formTarget, /labor/i

    it "Should add a driver", ->
      labor = expectedJob.laborA
      config.fillSelectize formTarget, "labor-type", labor.type
      config.fillInput formTarget, "quantity", labor.quantity
      config.fillInput formTarget, "time", labor.time
      config.fillSelectize formTarget, "time-units", labor.timeUnits, false
      config.fillInput formTarget, "price", labor.price
      config.fillSelectize formTarget, "price-units", labor.priceUnits, false
      config.checkComponentCost formTarget, labor.cost

    it "Should add a second labor component item", ->
      config.clickAdd formTarget
      config.checkAdditionalFormRow "labor", secondTarget

    it "Should add a tester", ->
      labor = expectedJob.laborB
      config.fillSelectize secondTarget, "labor-type", labor.type
      config.fillInput secondTarget, "quantity", labor.quantity
      config.fillInput secondTarget, "time", labor.time
      config.fillSelectize secondTarget, "time-units", labor.timeUnits, false
      config.fillInput secondTarget, "price", labor.price
      config.fillSelectize secondTarget, "price-units", labor.priceUnits, false
      config.checkComponentCost formTarget, labor.cost
      config.clickNext formTarget

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
