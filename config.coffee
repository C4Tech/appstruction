exports.config =
  plugins:
    coffeelint:
      pattern: /^app\/.*\.coffee$/

  paths:
    public: "build/www"

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
          "app/styles/cole.styl"
        ]

    templates:
      joinTo: "js/app.js"
