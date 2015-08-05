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
        "assets/app.js": /^app/
        "assets/vendor.js": /^(vendor|bower_components)/
    stylesheets:
      joinTo: "assets/style.css"
      order:
        before: [
          "app/styles/cordova.less"
          "app/styles/bootstrap.less"
          "app/styles/font-awesome.less"
        ]

  overrides:
    production:
      optimize: true
      sourceMaps: false
      plugins:
        autoReload:
          enabled: false
        cleancss:
          keepSpecialComments: 0
          removeEmpty: true
