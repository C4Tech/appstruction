Header = require "layout/header"

Grid = ReactBootstrap.Grid
RouteHandler = ReactRouter.RouteHandler

module.exports = React.createClass
  render: ->
    <Grid>
      <Header />

      <main>
        <RouteHandler />
      </main>
    </Grid>
