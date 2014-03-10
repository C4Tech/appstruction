Concrete Estimator
==================

Technical Details
-----------------

The concrete estimator is a simple application that runs on mobile devices
through the power of Cordova/PhoneGap. The 'real' application is built on top
of Backbone and Handlebars. Sources are written in CoffeeScript and Stylus.
Bower manages third-party dependencies, and Brunch assembles the sources and
dependencies into aggregated and minified scripts. The autoprefixer plugin to
Brunch automatically handles vendor-specific CSS differences.


Directory Structure
-------------------

/ - Repository root
|- app/ - Contains original code for the application
    |- assets/ - Contains static files which will copied by brunch on build
    |- models/ - Contains BackBone models written in CoffeeScript
    |- styles/ - Contains CSS written in Stylus
    |- templates/ - Contains Handlebars templates
    |- views/  - Contains BackBone views written in CoffeeScript
|- bower_components/ - Contains third-party UI components (e.g. Bootstrap)
|- build/ - Contains sources necessary for Cordova to compile
|- node_modules/ - Contains third-party NodeJS scripts


Build Requirements
------------------

1. [NodeJS](http://nodejs.org/) is a requirement for the build tools.
2. [Bower](http://bower.io/) manages the exteneral UI components.
3. [Brunch](http://brunch.io/) builds a usable application from the sources.
4. [Cordova](http://cordova.apache.org/) is used to export the application into 
   a usable mobile application.


How to Build From Source
------------------------

1. Run the installers: npm install && bower install
2. Build: brunch build
    - A browser-friendly version is available at ./build/www/devel.html
3. Compile: cordova build

A few script files are included in the repo to automate this process: 
compile-html, compile-cordova, and compile-all.
