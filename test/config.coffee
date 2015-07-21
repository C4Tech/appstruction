phantomcss = require "phantomcss"

# casper.on "page.initialized", ->
#   @evaluate ->
#     isFunction = (object) ->
#       typeof object is "function"

#     return if isFunction Function.prototype["bind"]
#       bind = (obj) ->
#         args = arguments.slice 1
#         noOp = -> {}
#         bound = =>
#           obj ?= {}
#           target = @ instanceof noOp ? @ : obj
#           @apply target, args.concat arguments.slice()

#         noOp.prototype = @prototype ? {}
#         bound.prototype = new noOp()
#         bound

#       Function.prototype.bind = bind

phantomcss.init
  prefixCount: true

module.exports =
  url: "http://localhost:3333/devel.html"
