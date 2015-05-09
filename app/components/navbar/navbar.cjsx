R = require 'ramda'
React = require 'react'

module.exports =
  React.createClass
    displayName: 'Navbar'

    render: ->
      <div className="ui navbar menu">
        <div className="header item">Beacon</div>
      </div>
