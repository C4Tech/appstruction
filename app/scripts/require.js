require.config({
    paths: {
        jquery: "lib/jquery",
        underscore: "lib/underscore",
        backbone: "lib/backbone",
        localstorage: "lib/backbone.localStorage"
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