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

expectedJob = config.job

return null

describe "Load Estimate", ->
  before ->
    casper.start config.url, ->
      @waitForSelector "section#home", ->
        @click "a[href='#browse']"

  it "Should start with the load page", ->
    casper.then ->
      @waitForSelector "section#browse", ->
        "section#browse".should.be.inDOM
        "section#browse .header-title .header-text".should.have.text /\s+Load an Estimate\s+/
        phantomcss.screenshot "section#browse > .navbar", "browse-navbar"

        phantomcss.screenshot "section#browse > .container", "browse-form"

  it "Should get a job", ->
    casper.then ->
      @evaluate ->
        foundJob = $("#browse-jobs option:nth-child(2)").val()
        $("#browse-jobs").select2 "val", foundJob, true

      @click "#browse-button"

  it "Should transition to the job summary page", ->
    casper.then ->
      @waitForSelector "section.page > .read-overview", ->
        phantomcss.screenshot "section.page > .read-overview", "summary-page"
