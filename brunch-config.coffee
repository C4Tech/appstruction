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
        "assets/vendor.js": /^(bower_components|vendor)/
    stylesheets:
      joinTo:
        "assets/app.css": /^(app|bower_components|vendor)/
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

  modules:
    wrapper: (path, data) ->
      # First trim the main directory from the name
      path = path.replace /^(app|bower_components|vendor)\//, ''

      # Trim file extensions
      path = path.replace /\.\w+$/, ''

      # Trim bower package paths
      path = path.replace /\/(dist(\/(js|global))?|source|build(\/(js|global))?|lib|scripts|js)/, ''

      # Trim duplicated path names
      path = path.replace /([A-Za-z0-9_\-\.]{3,})\/\1/gi, '$1'

      # Trim a few special cases
      path = path.replace /\/(index|ReactRouterBootstrap|ReactRouter|spin)$/, ''

      switch path
        when "react", "react-bootstrap", "react-router", "react-router-bootstrap", "reactable", "react-loader", "spin.js"
          return data

      path = JSON.stringify path

      """
require.register(#{path}, function(exports, require, module) {
  #{data}
});\n\n
      """
