config = require "./config"
phantomcss = require "phantomcss"

describe "Create Estimate", ->
  before ->
    casper.start "#{config.url}", ->
      @waitForSelector "section#home", ->
        @click "a.create-link:nth-child(1)"

  it "Should start with the job info page", ->
    casper.then ->
      @waitForSelector "section#create", ->
        "section#create".should.be.inDOM
        "section#create .header-title .header-text".should.have.text /\s+Job Builder\s+/
        phantomcss.screenshot "section#create .navbar", "add-navbar"
        phantomcss.screenshot "#job-form-create", "add-form"

  it "Should submit the job info form", ->
    casper.then ->
      @evaluate ->
        $("input[name='group_id']").select2 "val", "Test Group", true
        $("input[name='job_type']").select2 "val", "Commercial", true
        true

      @fillSelectors "#job-form-create > fieldset",
        "input[name='job_name']": "Job Testing"

      @click "#job-form-create button.ccma-navigate.next"

  it "Should transition to the concrete component page", ->
    casper.then ->
      @waitForSelector "section#concrete", ->
        "section#concrete".should.be.inDOM
        "section#concrete .header-job-name h3".should.have.text /job testing/i
        "section#concrete .header-title .header-text".should.have.text /concrete/i
        phantomcss.screenshot "section#concrete .navbar", "concrete-navbar"
        phantomcss.screenshot "#job-form-concrete", "concrete-form"
