K = require 'kefir'
R = require 'ramda'
React = require 'react'

App = require '../../data/apps'

ContainerBar = require './container-bar/container-bar'

Cluster = require '../cluster/cluster'

module.exports =
  React.createClass
    displayName: 'AppConfig'

    getInitialState: ->
      app: null
      draggingCluster:
        x: 0
        y: 0
        visible: false
        clusterName: ''
      clusters: []
      selectedClusterId: -1

    componentWillMount: ->
      @eventPool = K.pool()
      @eventPool
        .onValue((e) =>
          @setState(
            draggingCluster:
              x: e.x
              y: e.y
              visible: if e.type is 'dragend' then false else true
              containerName: e.containerName
          )
        )
        .onValue((e) =>
          if e.type is 'dragend'
            newClusters = R.append(R.pick(['x', 'y', 'containerName'], e), @state.clusters)
            @setState(clusters: newClusters, selectedClusterId: (newClusters.length - 1))
        )

    componentDidMount: ->
      App
        .getOne(@props.params.appid)
        .then (res) =>
          @setState(app: res.body)

    _handleContainerClick: (id) ->
      @setState(selectedClusterId: id)

    _renderCluster: (cluster, i) ->
      <Cluster
        key={i}
        id={i}
        x={cluster.x}
        y={cluster.y}
        type={cluster.containerName}
        onClick={@_handleContainerClick}
        selected={@state.selectedClusterId is i}
      />

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
              {R.mapIndexed(@_renderCluster)(@state.clusters)}
              <Cluster
                id={-1}
                type={@state.draggingCluster.containerName}
                x={@state.draggingCluster.x}
                y={@state.draggingCluster.y}
                visible={@state.draggingCluster.visible}
              />
            </div>
          </div>
          <div className="sidebar">
            <div className="settings">
              <h4>Choose a container in the template to view details</h4>
            </div>
            <ContainerBar className="container-bar" eventPool={@eventPool} />
          </div>
        </div>
