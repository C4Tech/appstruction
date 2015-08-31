Layout = require "layout/container"
Home = require "pages/home"
Browse = require "jobs/browse"
Read = require "jobs/read"
Add = require "jobs/add"
EditLayout = require "jobs/container"
Component = require "jobs/component-form"
Delete = require "jobs/delete"
Save = require "jobs/save"

Router = ReactRouter
Route = Router.Route
DefaultRoute = Router.DefaultRoute

routes =
  <Route name="home" path="/" handler={Layout}>
    <DefaultRoute handler={Home} />

    <Route name="browse" handler={Browse} />
    <Route name="read" handler={Read} />
    <Route name="add" handler={Add} />
    <Route name="edit" handler={EditLayout}>
      <Route name="component" path=":component" handler={Component} />
    </Route>
    <Route name="delete" handler={Delete} />

    <Route name="save" handler={Save} />
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
