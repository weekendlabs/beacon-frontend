R = require 'ramda'
React = require 'react'
Router = require 'react-router'

Apps = require '../../data/apps'
NewAppForm = require './new-app-form/new-app-form'

module.exports =
  React.createClass
    displayName: 'AppsPage'

    contextTypes:
      router: React.PropTypes.func.isRequired

    getInitialState: ->
      apps: null

    componentDidMount: ->
      # Fetch the apps
      Apps
        .getAll()
        .then (res) =>
          @setState(apps: res.body)

    _handleAppCreate: (appName) ->
      Apps
        .create(appName)
        .then (res) =>
          app = res.body
          @context.router.transitionTo('app-config', {appid: app._id})

    _handleAppClick: (e) ->
      {appId} = e.currentTarget.dataset
      @context.router.transitionTo('app-config', {appid: appId})

    _renderApps: (app) ->
      <div className="ui app basic segment" key={app._id} onClick={@_handleAppClick} data-app-id={app._id}>
        <div className="name">{app.name}</div>
      </div>

    render: ->
      unless @state.apps?
        <div className="ui apps page basic loading segment" />
      else
        <div className="ui apps page basic segment">
          <NewAppForm onCreate={@_handleAppCreate} />
          {R.map(@_renderApps)(@state.apps)}
        </div>
