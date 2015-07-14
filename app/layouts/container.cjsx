React = require "react"
ReactBootstrap = require "react-bootstrap"
ReactRouter = require "react-router"
Footer = require "./footer"
Header = require "./header"
require "./style.less"

Grid = ReactBootstrap.Grid
RouteHandler = ReactRouter.RouteHandler

module.exports = React.createClass
  render: ->
    <Grid fluid className="app">
      <Header />

      <main>
        <RouteHandler />
      </main>

      <Footer />
    </Grid>
