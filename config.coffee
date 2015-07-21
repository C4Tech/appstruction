exports.config =
  plugins:
    coffeelint:
      pattern: /^app\/.*\.coffee$/
    # afterBrunch: [
    #   "./node_modules/.bin/mocha-casperjs"
    # ]

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
          "app/styles/cole.less"
        ]

    templates:
      joinTo: "js/app.js"
