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
            <h3>Setup {@state.app.name}</h3>
            <div className="template-editor">

            </div>
          </div>
          <div className="sidebar">

          </div>
        </div>
