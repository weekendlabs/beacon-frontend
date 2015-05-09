R = require 'ramda'
React = require 'react'

module.exports =
  React.createClass
    displayName: 'ClusterComponent'

    propTypes:
      drawBorder: React.PropTypes.bool
      containerCount: React.PropTypes.number # Number of containers
      type: React.PropTypes.string

    getDefaultProps: ->
      drawBorder: true
      containerCount: 1
      type: ''

    _renderContainerCube: R.curry (type, i) ->
      <div key={i} className={"container-cube #{type}"} />

    render: ->
      size = @props.containerCount * 3 + 6

      getClusterContainerStyle = =>
        basicStyle =
          width: "#{size}em"
          height: "#{size}em"

        unless @props.drawBorder
          R.merge(basicStyle, {
            backgroundColor: 'transparent'
            backgroundImage: 'none'
            boxShadow: 'none'
          })
        else
          basicStyle

      <div
        className="cluster-container"
        style={getClusterContainerStyle()}>
        {R.times(@_renderContainerCube(@props.type))(@props.containerCount)}
      </div>
