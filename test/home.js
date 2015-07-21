require("./_init.js");
var phantomcss = require("phantomcss");

describe("Home page", function() {
  before(function() {
    casper.start("http://localhost:3333/devel.html");
  });

  it ("Should look the same", function() {
    casper.then(function() {
      casper.waitForSelector("section#home", function() {
        phantomcss.screenshot("section#home .navbar", "home-navbar");
        phantomcss.screenshot("section#home > .container > .row:nth-child(1)", "home-menu");
        phantomcss.screenshot("#footer-logo", "home-footer");
      });
    })
  });

  it("Should load with title", function() {
    casper.then(function() {
      "Appstruction".should.matchTitle;
    }, true);
  });
});
