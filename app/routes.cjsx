Router = ReactRouter
Route = Router.Route
DefaultRoute = Router.DefaultRoute

Layout = require "layout/container"
HomePage = require "pages/home"
JobInfo = require "jobs/info"
JobComponent = require "jobs/component-form"
JobOverview = require "jobs/overview"
LoadJob = require "jobs/load"
DeleteJob = require "jobs/delete"

routes =
  <Route name="home" path="/" handler={Layout}>
    <DefaultRoute handler={HomePage} />
    <Route name="job">
        <DefaultRoute handler={JobInfo} />
        <Route name="save" path="overview" handler={JobOverview} />
        <Route name="component" path=":component" handler={JobComponent} />
    </Route>

    <Route name="load" handler={LoadJob} />
    <Route name="delete" handler={DeleteJob} />
  </Route>

render = (target) ->
  (Handler) ->
    React.render <Handler />, target

module.exports =
  run: (target = document.body, history = true) ->
    location = ReactRouter.HistoryLocation
    renderer = render target

    return ReactRouter.run routes, location, renderer if history
    ReactRouter.run routes, renderer
