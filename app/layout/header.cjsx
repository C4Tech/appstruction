Grid = ReactBootstrap.Grid

Decoration = require "elements/header-decoration"
TopBar = require "layout/top-bar"

module.exports = React.createClass
  render: ->
    <header>
      <TopBar />
    </header>
