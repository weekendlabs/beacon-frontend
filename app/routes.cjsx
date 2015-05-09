React = require 'react'
Router = require 'react-router'
{Route, Redirect} = Router

Root = require './components/root/root'
AppsPage = require './components/apps-page/apps-page'

module.exports =
  <Route handler={Root}>
    <Route name="apps" handler={AppsPage} />
    <Redirect from="/" to="apps" />
  </Route>
