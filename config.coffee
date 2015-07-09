exports.config =
  plugins:
    coffeelint:
      pattern: /^app\/.*\.coffee$/
    autoprefixer:
      browsers: ["android >= 4"]
  paths:
    public: "www"
  files:
    javascripts:
      joinTo:
        "js/app.js": /^app/
        "js/vendor.js": /^(bower_components|vendor)/
    stylesheets:
      joinTo:
        "css/app.css": /^app/
        "css/vendor.css": /^(bower_components|vendor)/
      order:
        after: [
          "app/styles/cole.less"
        ]

    templates:
      joinTo: "js/app.js"
