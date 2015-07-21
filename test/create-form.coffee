config = require "./config"
phantomcss = require "phantomcss"

describe "Create Estimate", ->
  before ->
    casper.start "#{config.url}", ->
      @waitForSelector "section#home", ->
        @click "a.create-link:nth-child(1)"

  it "Should look right", ->
    casper.then ->
      @waitForSelector "section#create", ->
        "section#create".should.be.inDOM
        "section#create .header-title .header-text".should.have.text /\s+Job Builder\s+/
        phantomcss.screenshot "section#create .navbar", "add-navbar"
