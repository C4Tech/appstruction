phantomcss = require "phantomcss"

phantomcss.init
  prefixCount: true

# casper.on "remote.message", (message) ->
#     @echo "CONSOLE: #{message}"

module.exports =
  url: "http://localhost:3333/devel.html"
