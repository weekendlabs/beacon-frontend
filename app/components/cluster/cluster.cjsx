R = require 'ramda'
React = require 'react'

module.exports =
  React.createClass
    displayName: 'ClusterComponent'

    propTypes:
      id: React.PropTypes.number.isRequired
      drawBorder: React.PropTypes.bool
      containerCount: React.PropTypes.number # Number of containers
      visible: React.PropTypes.bool
      type: React.PropTypes.string
      x: React.PropTypes.number
      y: React.PropTypes.number
      onClick: React.PropTypes.func
      selected: React.PropTypes.bool

    getDefaultProps: ->
      drawBorder: true
      containerCount: 1
      type: ''
      visible: true
      selected: false

    _renderContainerCube: R.curry (type, i) ->
      <div
        key={i}
        className={"container-cube #{type.toLowerCase().replace(/\./gi, '-')}"}
        style={{opacity: if i isnt 0 then 0.25 else 1}}
      />

    _handleClick: ->
      if @props.onClick? then @props.onClick(@props.id)

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
          pointerEvents: if @props.visible then 'all' else 'none'
        })
      else
        R.merge(style, {
          opacity: if @props.visible then 1 else 0
          pointerEvents: if @props.visible then 'all' else 'none'
        })

    render: ->
      size = (Math.floor(Math.sqrt(@props.containerCount - 1)) * 3) + 9

      <div
        className={"cluster-container #{if @props.selected then 'selected' else ''}"}
        style={@_getClusterContainerStyle(size)}
        onClick={@_handleClick}
        >
        {R.times(@_renderContainerCube(@props.type))(@props.containerCount)}
      </div>
