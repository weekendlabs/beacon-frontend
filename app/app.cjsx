React = require 'react'
Router = require 'react-router'

routes = require './routes'

Router.run routes, (Handler) ->
  React.render <Handler />, document.body
