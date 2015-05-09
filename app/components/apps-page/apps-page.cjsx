R = require 'ramda'
React = require 'react'

Apps = require '../../data/apps'

module.exports =
  React.createClass
    displayName: 'AppsPage'

    getInitialState: ->
      apps: null

    componentDidMount: ->
      # Fetch the apps
      Apps
        .getAll()
        .then (res) =>
          @setState(apps: res.body)

    _renderApps: (app) ->
      <div className="ui app basic segment" key={app._id}>
        <div className="name">{app.name}</div>
      </div>

    render: ->
      unless @state.apps?
        <div className="ui apps page basic loading segment" />
      else
        <div className="ui apps page basic segment">
          {R.map(@_renderApps)(@state.apps)}
        </div>
