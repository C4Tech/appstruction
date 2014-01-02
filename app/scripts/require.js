require.config({
    paths: {
        jquery: "js/vendor.js",
        underscore: "js/vendor.js",
        backbone: "js/vendor.js",
        localstorage: "js/vendor.js"
    }
});

define("someCollection", ["localstorage"], function() {
    var SomeCollection = Backbone.Collection.extend({
        localStorage: new Backbone.LocalStorage("SomeCollection") // Unique name within your app.
    });

    return new SomeCollection();
});

require(["someCollection"], function(someCollection) {
  // ready to use someCollection
});