React = require "react"
ReactRouter = require "react-router"

Link = ReactRouter.Link

module.exports = React.createClass
  render: ->
    <div>
      <Link to="home" className="navbar-brand">
        Brand
      </Link>
    </div>

