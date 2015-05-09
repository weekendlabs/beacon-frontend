R = require 'ramda'
React = require 'react'

App = require '../../data/apps'

module.exports =
  React.createClass
    displayName: 'AppConfig'

    getInitialState: ->
      app: null

    componentDidMount: ->
      App
        .getOne(@props.params.appid)
        .then (res) =>
          @setState(app: res.body)

    render: ->
      unless @state.app?
        <div className="ui app-config page basic loading segment" />
      else
        <div className="ui app-config page basic segment">
          <div className="main-view">
            <div className="ui steps">
              <div className="active step">
                <i className="cube icon" />
                <div className="content">
                  <div className="title">App template</div>
                  <div className="description">Choose the containers and the stack you want to build</div>
                </div>
              </div>
              <div className="disabled step">
                <i className="cloud icon" />
                <div className="content">
                  <div className="title">Deploy Settings</div>
                  <div className="description">Provide additional details for deploying your app</div>
                </div>
              </div>
              <div className="disabled step">
                <i className="dashboard icon" />
                <div className="content">
                  <div className="title">Monitor</div>
                  <div className="description">Monitor your cluster and aggregated statistics</div>
                </div>
              </div>
            </div>

            <div className="template-editor">

            </div>
          </div>
          <div className="sidebar">

          </div>
        </div>
