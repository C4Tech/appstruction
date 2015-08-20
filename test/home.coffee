config = require "./config"
phantomcss = require "phantomcss"

describe "Home page", ->
  before ->
    casper.thenOpen config.url, ->

  it "Should look the same", ->
    casper.waitForSelector "article#home", ->
      phantomcss.screenshot config.navbarSelector, "home-navbar"
      phantomcss.screenshot "article div.row", "home-menu"
      phantomcss.screenshot "article footer", "home-footer"

  it "Should load with title", ->
    casper.then ->
      "Appstruction".should.matchTitle
