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

  describe "Labor Component Form", ->
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
    formTarget = "form#material"
    secondTarget = "#{formTarget} > .item:nth-child(2)"
    thirdTarget = "#{formTarget} > .item:nth-child(3)"

    it "Should transition to the material component page", ->
      config.checkFormPage "material", formTarget, /materials/i

    it "Should add wires", ->
      material = expectedJob.materialA

      config.fillSelectize formTarget, "material-type", material.type
      config.fillInput formTarget, "quantity", material.quantity
      config.fillInput formTarget, "price", material.price
      config.fillInput formTarget, "tax", material.tax
      config.checkComponentCost formTarget, material.cost

    it "Should add a second material component item", ->
      config.clickAdd formTarget
      config.checkAdditionalFormRow "material", secondTarget

    it "Should add adamantium", ->
      material = expectedJob.materialB

      config.fillSelectize secondTarget, "material-type", material.type
      config.fillInput secondTarget, "quantity", material.quantity
      config.fillInput secondTarget, "price", material.price
      config.fillInput secondTarget, "tax", material.tax
      config.checkComponentCost formTarget, material.cost

    it "Should add a third material component item", ->
      config.clickAdd formTarget
      config.checkAdditionalFormRow "material", thirdTarget

    it "Should add caps", ->
      material = expectedJob.materialC

      config.fillSelectize thirdTarget, "material-type", material.type
      config.fillInput thirdTarget, "quantity", material.quantity
      config.fillInput thirdTarget, "price", material.price
      config.fillInput thirdTarget, "tax", material.tax
      config.checkComponentCost formTarget, material.cost
      config.clickNext formTarget

  describe "Equipment Component Form", ->
    formTarget = "form#equipment"

    it "Should transition to the equipment component page", ->
      config.checkFormPage "equipment", formTarget, /equipment/i

    it "Should add bobcat", ->
      equipment = expectedJob.equipment

      config.fillSelectize formTarget, "equipment-type", equipment.type
      config.fillInput formTarget, "quantity", equipment.quantity
      config.fillInput formTarget, "time", equipment.time
      config.fillSelectize formTarget, "time-units", equipment.timeUnits
      config.fillInput formTarget, "price", equipment.price
      config.fillSelectize formTarget, "price-units", equipment.priceUnits
      config.checkComponentCost formTarget, equipment.cost
      config.clickNext formTarget

  return describe "Subcontractor Component Form", ->
    formTarget = "form#subcontractor"

    it "Should transition to the subcontractor component page", ->
      config.checkFormPage "subcontractor", formTarget, /subcontractor/i

    it "Should add subcontractor", ->
      subcontractor = expectedJob.subcontractor

      config.fillInput formTarget, "scope", subcontractor.scope
      config.fillInput formTarget, "cost", subcontractor.cost
      # config.checkComponentCost formTarget, subcontractor.cost
      config.clickNext formTarget

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
