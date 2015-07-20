var fs = require( "fs" );
var phantomcss = require("phantomcss");

casper.on( "page.initialized", function() {
  this.evaluate(function() {
    var isFunction = function (o) {
      return typeof o === "function";
    };

    var bind,
      slice = [].slice,
      proto = Function.prototype,
      featureMap;

    featureMap = {
      "function-bind": "bind"
    };

    function has(feature) {
      var prop = featureMap[feature];
      return isFunction(proto[prop]);
    }

    if (!has("function-bind")) {
      bind = function bind(obj) {
        var args = slice.call(arguments, 1),
          self = this,
          nop = function() {
          },
          bound = function() {
            return self.apply(this instanceof nop ? this : (obj || {}), args.concat(slice.call(arguments)));
          };
        nop.prototype = this.prototype || {};
        bound.prototype = new nop();
        return bound;
      };
      proto.bind = bind;
    }
  });
});


phantomcss.init();

describe("Home page", function() {
  before(function() {
    casper.start("http://localhost:3333/devel.html");
  });

  it ("Should look the same", function() {
    casper.then(function() {
      casper.waitForSelector("body > .container", function() {
        phantomcss.screenshot("body > .container", "homepage");
      });
    })
  });

  it("Should load with title", function() {
    casper.then(function() {
      "Appstruction".should.matchTitle;
    }, true);
  });
});
