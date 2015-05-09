R = require 'ramda'
React = require 'react'

module.exports =
  React.createClass
    displayName: 'ClusterComponent'

    propTypes:
      drawBorder: React.PropTypes.bool
      containerCount: React.PropTypes.number # Number of containers
      visible: React.PropTypes.bool
      type: React.PropTypes.string
      x: React.PropTypes.number
      y: React.PropTypes.number

    getDefaultProps: ->
      drawBorder: true
      containerCount: 1
      type: ''
      visible: true

    _renderContainerCube: R.curry (type, i) ->
      <div key={i} className={"container-cube #{type.toLowerCase().replace(/\./gi, '-')}"} />

    _getClusterContainerStyle: (size) ->
      basicStyle =
        width: "#{size}em"
        height: "#{size}em"

      style =
        unless @props.drawBorder
          R.merge(basicStyle, {
            backgroundColor: 'transparent'
            backgroundImage: 'none'
            boxShadow: 'none'
          })
        else
          # TODO: Make this relative to size formula
          R.merge(basicStyle, {
            marginTop: '-7.5em'
            marginLeft: '-7.5em'
          })

      if @props.x or @props.y
        R.merge(style, {
          position: 'absolute'
          left: @props.x, top: @props.y
          opacity: if @props.visible then 1 else 0
        })
      else
        R.merge(style, {opacity: if @props.visible then 1 else 0})

    render: ->
      size = @props.containerCount * 3 + 6

      <div
        className="cluster-container"
        style={@_getClusterContainerStyle(size)}>
        {R.times(@_renderContainerCube(@props.type))(@props.containerCount)}
      </div>
