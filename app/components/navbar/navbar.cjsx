R = require 'ramda'
React = require 'react'
Reflux = require 'reflux'

actions = require '../../actions/actions'

module.exports =
  React.createClass
    displayName: 'Navbar'

    mixins: [
      Reflux.listenTo(actions.setNavbarChildren, "_onSetNavbarChildren")
      Reflux.listenTo(actions.removeNavbarChildren, "_onRemoveNavbarChildren")
    ]

    getInitialState: ->
      children: []

    _onSetNavbarChildren: (children) ->
      @setState(children: children)

    _onRemoveNavbarChildren: ->
      @setState(children: [])

    render: ->
      <div className="navbar">
        <div className="ui fixed menu">
          <div className="header item">Beacon</div>
          {@state.children}
        </div>
      </div>
