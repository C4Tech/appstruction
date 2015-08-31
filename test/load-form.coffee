config = require "./config"
phantomcss = require "phantomcss"

expectedJob = config.job

describe "Load Estimate", ->
  before ->
    casper.start config.url, ->
      @waitForSelector "article#home", ->
        @clickLabel "Load saved estimate"

  describe "Job Browse Page", ->
    formTarget = "form#browse"

    it "Should transition to the job browse page", ->
      casper.waitForSelector formTarget, ->
        formTarget.should.be.inDOM
        phantomcss.screenshot formTarget, "browse-form"

    it "Should get a job", ->
      config.fillSelectize formTarget, "job-select", expectedJob.name
      config.clickNext formTarget

  describe "Job Summary Page", ->
    it "Should transition to the job summary page", ->
      config.checkPage "summary", "article.job-summary"
