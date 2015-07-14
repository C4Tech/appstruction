Icon = require "react-fa/dist/Icon.js"
React = require "react"
ReactBootstrap = require "react-bootstrap"
# ReactRouterBootstrap = require "react-router-bootstrap"
Brand = require "./brand"

Nav = ReactBootstrap.Nav
Navbar = ReactBootstrap.Navbar
NavItem = ReactBootstrap.NavItem

module.exports = React.createClass
  render: ->
    <Navbar brand={<Brand />} inverse fluid>
      <Nav navbar eventKey={2}>
        <NavItem href="#">Nav One</NavItem>
        <NavItem href="#">Nav Two</NavItem>
        <NavItem href="#">Nav Three</NavItem>
      </Nav>

      <Nav navbar right eventKey={4}>
        <NavItem href="#"><Icon name="cog" size="lg" /></NavItem>
      </Nav>
    </Navbar>
