config = require "./config"
phantomcss = require "phantomcss"

describe "Home page", ->
  before ->
    casper.start config.url

  it "Should look the same", ->
    casper.then ->
      @waitForSelector "section#home", ->
        phantomcss.screenshot "section#home .navbar", "home-navbar"
        phantomcss.screenshot "section#home > .container > .row:nth-child(1)", "home-menu"
        phantomcss.screenshot "#footer-logo", "home-footer"

  it "Should load with title", ->
    casper.then ->
      "Appstruction".should.matchTitle
