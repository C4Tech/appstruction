exports.config =
  plugins:
    coffeelint:
      pattern: /^app\/.*\.coffee$/
      options:
        ensure_comprehensions:
          level: "ignore"
    postcss:
      processors: [
        require("autoprefixer") ["android >= 4"]
        require "csswring"
      ]
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
