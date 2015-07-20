exports.config =
  plugins:
    coffeelint:
      pattern: /^app\/.*\.coffee$/
    autoprefixer:
      browsers: ["android >= 4"]
    afterBrunch: [
      './node_modules/.bin/mocha-casperjs test test/index.js'
    ]

  paths:
    public: "www"

  files:
    javascripts:
      joinTo:
        "assets/app.js": /^app/
        "assets/vendor.js": /^(bower_components|vendor)/
    stylesheets:
      joinTo:
        "assets/style.css": /^(app|bower_components|vendor)/
      order:
        after: [
          "app/styles/cole.less"
        ]

    templates:
      joinTo: "assets/app.js"

  overrides:
    production:
      sourceMaps: false
      plugins:
        cleancss:
          keepSpecialComments: 0
          removeEmpty: true
