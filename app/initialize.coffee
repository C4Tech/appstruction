log.setLevel "warn"

require "choices/store"
require "jobs/store"
route = require "routes"

window.App = route.run()
