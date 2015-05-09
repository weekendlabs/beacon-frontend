R = require 'ramda'
React = require 'react'

module.exports =
  React.createClass
    displayName: 'ClusterSettings'

    propTypes:
      className: React.PropTypes.string
      cluster: React.PropTypes.object.isRequired

    render: ->
      <form className="ui form">
        <div className="ui header">{@props.cluster.containerName}</div>
        <div className="input field">
          <input type="url" placeholder="Github URL (http)" />
        </div>
        <div className="input field">
          <input type="text" placeholder="Github Token" />
        </div>
        <div className="two fields">
          <div className="ui input field">
            <input type="number" placeholder="Minimum" />
          </div>
          <div className="ui input field">
            <input type="number" placeholder="Maximum" />
          </div>
        </div>
      </form>
