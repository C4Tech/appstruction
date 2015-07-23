Concrete Estimator
==================

Technical Details
-----------------

The concrete estimator is a simple application that runs on mobile devices
through the power of PhoneGap. The 'real' application is built on top
of React and Flux. Sources are written in CoffeeScript and LESS.
Bower manages third-party dependencies, and Brunch assembles the sources and
dependencies into aggregated and minified scripts. The autoprefixer plugin to
Brunch automatically handles vendor-specific CSS differences.


Directory Structure
-------------------

/ - Repository root
|- app/ - Contains original code for the application
|- bower_components/ - Contains third-party UI components (e.g. Bootstrap)
|- hooks/ - Contains addon hooks for PhoneGap
|- node_modules/ - Contains third-party NodeJS scripts
|- platforms/ - Contains platform configurations for PhoneGap
|- plugins/ - Contains addons for PhoneGap
|- screenshots/ - Contains screenshots of the interface with expected styling
|- test/ - Contains test scripts
|- www/ - Generated web app which gets injected into PhoneGap builds

Build Requirements
------------------

1. [NodeJS](http://nodejs.org/) is a requirement for the build tools.
2. [Bower](http://bower.io/) manages the exteneral UI components.
3. [Brunch](http://brunch.io/) builds a usable application from the sources.
4. [PhoneGap](http://phonegap.com/) is used to export the application into
   a usable mobile application.

tl;dr: Install NodeJS and `npm install --global bower brunch phonegap`

How to Build From Source
------------------------

1. Build the HTML: npm start
    - A browser-friendly version is available at ./build/www/devel.html
2. Build the Android app: `npm run compile`
3. Rebuild the HTML: `npm run rebuild`
4. Rebuild the Android app: `npm run recompile`
5. Start over: `npm run start-over`


Testing
-------

We are using a mixture of PhantomJS, CasperJS, Mocha, Chai. Each test
steps through a process (e.g. creating an estimate), verifying that
each step works properly. Additionally, we are using PhantomCSS to
catch any style regressions.

Run `npm test`. PhantomCSS captures are stored in the `screenshots`
directory.
