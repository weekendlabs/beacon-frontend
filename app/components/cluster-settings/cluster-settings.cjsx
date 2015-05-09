R = require 'ramda'
React = require 'react'

module.exports =
  React.createClass
    displayName: 'ClusterSettings'

    propTypes:
      className: React.PropTypes.string
      cluster: React.PropTypes.object.isRequired
      onChange: React.PropTypes.func.isRequired

    _handleFormChange: (e) ->
      form = e.currentTarget
      githubUrl = form['url'].value
      githubToken = form['token'].value
      min = parseInt(form['min'].value)
      max = parseInt(form['max'].value)

      newCluster = R.merge(@props.cluster, {
        github:
          url: githubUrl
          token: githubToken
        min: min
        max: max
      })

      @props.onChange(newCluster)

    render: ->
      <form className="ui form" onChange={@_handleFormChange}>
        <div className="ui header">{@props.cluster.containerName}</div>
        <div className="input field">
          <input name="url" type="url" placeholder="Github URL (http)" value={@props.cluster.github.url} />
        </div>
        <div className="input field">
          <input name="token" type="text" placeholder="Github Token" value={@props.cluster.github.token} />
        </div>
        <div className="two fields">
          <div className="ui input field">
            <input name="min" type="number" placeholder="Minimum" value={@props.cluster.min} />
          </div>
          <div className="ui input field">
            <input name="max" type="number" placeholder="Maximum" value={@props.cluster.max} />
          </div>
        </div>
      </form>
