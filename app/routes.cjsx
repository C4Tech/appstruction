Router = ReactRouter
Route = Router.Route
DefaultRoute = Router.DefaultRoute

AdminDashboard = require "admin/dashboard"
AdminBusinesses = require "businesses/browse"
AdminUsers = require "users/browse"
AppContainer = require "app/container"
BusinessProfile = require "businesses/profile"
ManageBusiness = require "businesses/manage"
FrontHome = require "front/home"
Confirm = require "app/confirm"
Logout = require "app/logout"
ProfileContainer = require "profile/container"
ProfileHome = require "profile/home"


routes =
  <Route name="home" path="/" handler={AppContainer}>
    <DefaultRoute handler={FrontHome} />

    <Route name="profile" handler={ProfileContainer}>
      <DefaultRoute handler={ProfileHome} />
    </Route>

    <Route path="vendors">
      <Route name="business.profile" path=":shortName/?:tabPane?" handler={BusinessProfile} />
      <DefaultRoute handler={FrontHome} />
    </Route>

    <Route name="admin">
      <DefaultRoute handler={AdminDashboard} />
      <Route name="admin.businesses" path="businesses">
        <Route name="business.manage" path=":businessId" handler={ManageBusiness} />
        <DefaultRoute handler={AdminBusinesses} />
      </Route>
      <Route name="admin.users" path="users" handler={AdminUsers} />
    </Route>

    <Route path="confirm/:confirmCode" handler={Confirm} />
    <Route name="logout" handler={Logout} />
  </Route>

render = (target) ->
  (Handler) ->
    React.render <Handler/>, target

module.exports =
  run: (target = document.body, history = true) ->
    return Router.run routes, Router.HistoryLocation, render target if history
    Router.run routes, render target
