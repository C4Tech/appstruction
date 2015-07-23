phantomcss = require "phantomcss"

phantomcss.init
  prefixCount: true

# casper.on "remote.message", (message) ->
#   @echo "#{message}", "COMMENT"

casper.on "remote.alert", (message) ->
  @echo "ALERT: #{message}", "WARNING"


module.exports =
  url: "http://localhost:8080/devel.html"
