R = require 'ramda'
K = require 'kefir'
React = require 'react/addons'

{LinkedStateMixin} = React.addons

Cluster = require '../../cluster/cluster'

module.exports =
  React.createClass
    displayName: 'ContainerBar'

    mixins: [LinkedStateMixin]

    propTypes:
      className: React.PropTypes.string
      containers: React.PropTypes.array
      eventPool: React.PropTypes.object.isRequired

    getDefaultProps: ->
      containers: [
        {type: 'compute', name: 'NodeJS'}
        {type: 'compute', name: 'io.js'}
        {type: 'compute', name: 'Rails'}
        {type: 'compute', name: 'Ruby'}
        {type: 'compute', name: 'Nginx'}
        {type: 'compute', name: 'Apache2'}
        {type: 'compute', name: 'Tomcat'}
        {type: 'compute', name: 'Django'}
        {type: 'compute', name: 'Clojure'}
        {type: 'database', name: 'MySQL'}
        {type: 'database', name: 'Postgre'}
        {type: 'database', name: 'MongoDB'}
        {type: 'database', name: 'RethinkDB'}
      ]

    getInitialState: ->
      textFilter: ''

    componentDidMount: ->
      @tempPool = K.pool()

      @mouseDownStream = K.emitter()
      mouseMoveStream = K.fromEvents(window, 'mousemove').map (e) -> {type: e.type, x: e.clientX, y: e.clientY}
      mouseUpStream = K.fromEvents(window, 'mouseup').map (e) -> {type: e.type, x: e.clientX, y: e.clientY}

      @tempPool.plug(@mouseDownStream)

      @mouseDownStream.onValue =>
        @tempPool.plug(mouseMoveStream)
        @tempPool.plug(mouseUpStream)

      @tempPool.onValue (e) =>
        if e.type is 'mouseup'
          @tempPool.unplug(mouseMoveStream)
          @tempPool.unplug(mouseUpStream)

      @props.eventPool.plug(
        @tempPool
          .scan (prev, next) ->
            if next.type isnt 'mousedown'
              R.merge(next, {containerName: prev.containerName})
            else next
          .scan (prev, next) ->
            if prev.type is 'mousedown' and next.type is 'mousemove'
              R.merge(next, {type: 'dragstart'})
            else if prev.type is 'mousedown' and next.type is 'mouseup'
              R.merge(next, {type: ''})
            else if prev.type is 'mousemove' and next.type is 'mouseup'
              R.merge(next, {type: 'dragend'})
            else next
          .filter (e) -> R.contains(e.type)(['dragstart', 'mousemove', 'dragend'])
          .map (e) ->
            if e.type is 'mousemove' then R.merge(e, {type: 'drag'})
            else e
      )

    _handleMouseDown: (e) ->
      e.preventDefault()
      containerName = e.currentTarget.dataset.containerName
      @mouseDownStream.emit({
        type: 'mousedown', containerName
        x: e.clientX
        y: e.clientY
      })

    _renderContainer: (container, i) ->
      <div
        className="container"
        key={container.name}
        id={i}
        data-container-name={container.name}
        onMouseDown={@_handleMouseDown}
      >
        <Cluster id={i} drawBorder={false} type={container.name} />
        <div className="name">{container.name}</div>
      </div>

    _getContainers: (containers, textFilter) ->
      R.filter((container) ->
        R.match(new RegExp(textFilter, 'gi'), container.name)
      )(containers)

    render: ->
      <div className={@props.className}>
        <div className="ui fluid icon input">
          <input
            type="text"
            placeholder="Filter containers"
            valueLink={@linkState('textFilter')}
          />
          <i className="filter icon"></i>
        </div>
        <div className="containers-container">
          {R.mapIndexed(@_renderContainer)(@_getContainers(@props.containers, @state.textFilter))}
        </div>
      </div>
