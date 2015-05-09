R = require 'ramda'
React = require 'react'
Router = require 'react-router'

{RouteHandler} = Router
Navbar = require '../navbar/navbar'

module.exports =
  React.createClass
    displayName: 'Root'

    render: ->
      <div className="app">
        <Navbar />
        <RouteHandler />
      </div>
