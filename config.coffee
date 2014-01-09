exports.config =
  plugins:
    coffeelint:
      pattern: /^app\/.*\.coffee$/

  paths:
    public: "build/www"

  modules:
    wrapper: false

  files:
    javascripts:
      joinTo:
        "js/app.js": /^app/
        "js/vendor.js": /^(bower_components|vendor)/
      order:
        before: [
          "app/scripts/backbone.coffee",
          "app/scripts/material.coffee",
          "app/scripts/labor.coffee",
          "app/scripts/equipment.coffee",
          "app/scripts/job.coffee",
          "app/scripts/activeJob.coffee",
          "app/scripts/cordova.coffee",
          "app/scripts/saveJob.js",
          "app/scripts/backboneview.coffee"
        ],
        after: [
          "app/scripts/lungo.coffee"
          "app/scripts/job.coffee"
        ]

    stylesheets:
      joinTo:
        "css/app.css": /^app/
        "css/vendor.css": /^(bower_components|vendor)/
