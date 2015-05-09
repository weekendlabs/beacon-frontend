R = require 'ramda'
React = require 'react/addons'

{LinkedStateMixin} = React.addons

module.exports =
  React.createClass
    displayName: 'NewAppForm'

    mixins: [LinkedStateMixin]

    propTypes:
      onCreate: React.PropTypes.func.isRequired

    getInitialState: ->
      name: ''

    _handleSubmit: (e) ->
      e.preventDefault()
      unless R.isEmpty(@state.name)
        @props.onCreate(@state.name)
        @setState(name: '')

    render: ->
      <form className="ui app form basic segment" onSubmit={@_handleSubmit}>
        <div className="title">Create a new app</div>
        <div className="inputs">
          <div className="ui fluid input">
            <input type="text" placeholder="App name" valueLink={@linkState('name')} />
          </div>
          <input
            className="ui primary button"
            type="submit" value="Create"
          />
        </div>
      </form>
