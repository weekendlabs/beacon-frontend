R = require 'ramda'
React = require 'react'
Router = require 'react-router'
moment = require 'moment'

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
          apps = res.body
          @setState(apps: apps)

          R.mapIndexed((app, i) =>
            lineChartData = [{
              label: "CPU"
              values: [{time: moment.utc().valueOf(), y: 100.0}]
            }, {
              label: "Memory"
              values: [{time: moment.utc().valueOf(), y: 100.0}]
            }]

            lineChart = $(@refs["area#{i}"].getDOMNode()).epoch(
              type: 'time.line'
              data: lineChartData
              ticks: {time: 25}
              tickFormats: { time: (d) -> new Date(time*1000).toString() }
            )

            kbps = $(@refs["kbps#{i}"].getDOMNode())

            Apps
              .statsStream(res.body[0]._id)
              .onValue (stat) =>
                lineChart.push([{
                  time: moment.utc().valueOf()
                  y: stat.c
                }, {
                  time: moment.utc().valueOf()
                  y: stat.m
                }])

                kbps.html(stat.n)
            )(apps)


    _handleAppCreate: (appName) ->
      Apps
        .create(appName)
        .then (res) =>
          app = res.body
          @context.router.transitionTo('app-config', {appid: app._id})

    _handleAppClick: (e) ->
      {appId} = e.currentTarget.dataset
      @context.router.transitionTo('app-config', {appid: appId})

    _renderApp: (app, i) ->
      <div className="ui app basic segment" key={app._id} onClick={@_handleAppClick} data-app-id={app._id}>
        <div className="name">{app.name}</div>
        <div className="metrics-container">
          <div ref={"area#{i}"} className="epoch category10" style={{height: 150}} />
          <div className="ui statistic">
            <div ref={"kbps#{i}"} className="value" style={{textAlign: 'center'}}></div>
          </div>
        </div>
      </div>

    render: ->
      unless @state.apps?
        <div className="ui apps page basic loading segment" />
      else
        <div className="ui apps page basic segment">
          <NewAppForm onCreate={@_handleAppCreate} />
          {R.mapIndexed(@_renderApp)(@state.apps)}
        </div>
