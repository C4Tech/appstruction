system = require "system"

module.exports = class NavigationActions
  set: (payload) ->
    @dispatch payload

  setNext: (link, param) ->
    @dispatch
      link: link
      param: param

  setPrev: (link, param) ->
    @dispatch
      link: link
      param: param

  setTitle: (title) ->
    @dispatch
      title: title

module.exports = system.createActions NavigationActions
