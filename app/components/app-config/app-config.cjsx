K = require 'kefir'
R = require 'ramda'
React = require 'react'

App = require '../../data/apps'

ContainerBar = require './container-bar/container-bar'
Cluster = require '../cluster/cluster'
ClusterSettings = require '../cluster-settings/cluster-settings'

actions = require '../../actions/actions'

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
      showDeployForm: false

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
            newClusters = R.append(
              R.merge(
                R.pick(
                  ['x', 'y', 'containerName'], e),
                  {name: 'node', github: {url: '', token: ''}, min: 1, max: 1}
                ),
                @state.clusters
              )
            @setState(clusters: newClusters, selectedClusterId: (newClusters.length - 1))
        )

    componentDidMount: ->
      App
        .getOne(@props.params.appid)
        .then (res) =>
          console.log res.body
          config = JSON.parse(res.body.config)
          @setState(
            app: res.body
            clusters: if config.clusters? then config.clusters else []
          )

      actions.setNavbarChildren([
        <div className="ui right menu" key="deploy-button">
          <div className="item">
            <div className="ui green button" onClick={@_handleDeployButtonClick}>Deploy</div>
          </div>
        </div>
      ])

    componentWillUnmount: ->
      actions.removeNavbarChildren()

    _handleDeployButtonClick: ->
      @setState(showDeployForm: true)

    _handleDeployFormCancel: ->
      @setState(showDeployForm: false)

    _handleContainerClick: (id) ->
      @setState(selectedClusterId: id)

    _handleClusterChange: (i) -> (newCluster) =>
      newClusters = R.compose(
        R.insert(i, newCluster)
        R.remove(i, 1)
      )(@state.clusters)

      @setState(clusters: newClusters)

    _handleDeployFormSubmit: (e) ->
      e.preventDefault()
      accessKey = e.currentTarget['aws-access-key'].value
      secretKey = e.currentTarget['aws-secret-key'].value

      newConfig = R.merge( JSON.parse(@state.app.config or "{}"), {
        aws:
          accessKey: accessKey
          secretKey: secretKey
        clusters: R.map((cluster) ->
          containerName: cluster.containerName
          name: 'node'
          x: cluster.x
          y: cluster.y
          github:
            url: 'https://github.com/lalith26/beacon-sample-app.git'
            token: '594671659b92ca45afdb46d6c64402265a98a44e'
          min: cluster.min
          max: cluster.max
        )(@state.clusters)
      })

      App
        .putConfig(@state.app._id, newConfig)
        .then (res) =>
          console.log res
          console.log 'put new config finished'
          App.deploy(@state.app._id)
        .then (res) =>
          console.log res

    _renderCluster: (cluster, i) ->
      <Cluster
        key={i}
        id={i}
        x={cluster.x}
        y={cluster.y}
        type={cluster.containerName}
        onClick={@_handleContainerClick}
        selected={@state.selectedClusterId is i}
        containerCount={cluster.max}
      />

    render: ->
      unless @state.app?
        <div className="ui app-config page basic loading segment" />
      else
        settings =
          if @state.selectedClusterId isnt -1
            <div className="cluster-settings">
              <ClusterSettings
                cluster={@state.clusters[@state.selectedClusterId]}
                onChange={@_handleClusterChange(@state.selectedClusterId)}
              />
            </div>
          else
            <div className="ui basic cluster-settings disabled segment">
              <h4>Cluster Settings</h4>
            </div>

        blankEditorMessage =
          <div className="ui basic segment blank-message">
            <h4>Drag and drop your containers to define clusters</h4>
          </div>

        deployForm =
          <div className={"deploy-form #{if @state.showDeployForm then 'visible' else ''}"}>
            <form className="ui form basic segment" onSubmit={@_handleDeployFormSubmit}>
              <h3>Deploy your clusters</h3>
              <div className="ui input field">
                <input name="aws-access-key" type="text" placeholder="AWS Access Key" defaultValue="AKIAIAAZ7VPUJCPVXWFQ" />
              </div>
              <div className="ui input field">
                <input name="aws-secret-key" type="text" placeholder="AWS Secret Key" defaultValue="dA2kRk0N/wO33CByG3jfBPGibapubx9hxmIuvAw2" />
              </div>
              <input className="ui primary button" type="submit" />
              <div className="ui default button" onClick={@_handleDeployFormCancel}>Cancel</div>
            </form>
          </div>

        <div className="ui app-config page basic segment">
          {deployForm}
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
              {unless R.isEmpty(@state.clusters) then R.mapIndexed(@_renderCluster)(@state.clusters) else blankEditorMessage}
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
            {settings}
            <ContainerBar className="container-bar" eventPool={@eventPool} />
          </div>
        </div>
