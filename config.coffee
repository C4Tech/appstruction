exports.config =
  plugins:
    sass:
      debug: 'comments'
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(bower_components)/
    stylesheets:
      joinTo:
        'stylesheets/app.css': /^(app|bower_components)/
    templates:
      joinTo: 'javascripts/app.js'

