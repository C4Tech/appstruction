React = require "react"
UserBar = require "./user-bar"

module.exports = React.createClass
  render: ->
    <header>
      <UserBar />
    </header>
