exports.config =
  plugins:
    sass:
      debug: "comments"

  paths:
    public: "build/www"

  files:
    javascripts:
      joinTo:
        "js/app.js": /^app/
        "js/vendor.js": /^(bower_components|vendor)/
      order:
        before: [
          "bower_components/jquery/jquery.js",
          "app/scripts/cordova.js",
          "app/scripts/lungo.js"
        ]

    stylesheets:
      joinTo:
        "css/app.css": /^app/
        "css/vendor.css": /^(bower_components|vendor)/
      order:
        before: [
          "bower_components/lungo/lungo.css"
        ]

    templates:
      joinTo: "js/layout.js"
