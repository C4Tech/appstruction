Router = ReactRouter
Route = Router.Route
DefaultRoute = Router.DefaultRoute

Layout = require "layout/container"
Home = require "pages/home"
Component = require "jobs/component-form"
JobLayout = require "jobs/container"
Add = require "jobs/add"
# JobOverview = require "jobs/overview"
# LoadJob = require "jobs/load"
# DeleteJob = require "jobs/delete"

  # <Route name="browse" handler={LoadJob} />
  # <Route name="delete" handler={DeleteJob} />
    # <Route name="save" path="overview" handler={JobOverview} />
routes =
  <Route name="home" path="/" handler={Layout}>
    <DefaultRoute handler={Home} />

    <Route name="add" handler={Add} />
    <Route name="job" handler={JobLayout}>
      <Route name="component" path=":component" handler={Component} />
    </Route>
  </Route>

render = (target) ->
  (Handler) ->
    React.render <Handler />, target

module.exports =
  run: (target = document.body, history = false) ->
    location = ReactRouter.HistoryLocation
    renderer = render target

    return ReactRouter.run routes, location, renderer if history
    ReactRouter.run routes, renderer
