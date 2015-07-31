system = require "system"

module.exports = class NavigationActions
  constructor: ->
    @generateActions "set",
      "setTitle",
      "unset",
      "unsetNext",
      "unsetPrev",
      "unsetTitle"

  setNext: (link, param) ->
    @dispatch
      link: link
      param: param

  setPrev: (link, param) ->
    @dispatch
      link: link
      param: param

module.exports = system.createActions NavigationActions
