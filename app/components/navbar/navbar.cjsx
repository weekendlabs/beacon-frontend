R = require 'ramda'
React = require 'react'

module.exports =
  React.createClass
    displayName: 'Navbar'

    render: ->
      <div className="navbar">
        <div className="ui fixed menu">
          <div className="header item">Beacon</div>
        </div>
      </div>
