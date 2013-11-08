exports.config =
  plugins:
    sass:
      debug: "comments"

  paths:
    public: "build"

  files:
    javascripts:
      joinTo:
        "www/js/app.js": /^app/
        "www/js/vendor.js": /^(bower_components|vendor)/
      order:
        before: [
          "bower_components/jquery/jquery.js"
        ]

    stylesheets:
      joinTo:
        "www/css/app.css": /^app/
        "www/css/vendor.css": /^(bower_components|vendor)/
      order:
        before: [
          "bower_components/lungo/lungo.css"
        ]

    templates:
      joinTo: "www/js/layout.js"
