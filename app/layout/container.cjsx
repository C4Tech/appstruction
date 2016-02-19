Header = require "layout/header"

Grid = ReactBootstrap.Grid
RouteHandler = ReactRouter.RouteHandler

module.exports = React.createClass
  render: ->
    <div className="application">
      <Header />
      <Grid componentClass="main">
        <RouteHandler />
      </Grid>
    </div>
