React = require 'react'
Router = require 'react-router'
{Route, Redirect} = Router

Root = require './components/root/root'
AppsPage = require './components/apps-page/apps-page'
AppConfigPage = require './components/app-config/app-config'

module.exports =
  <Route handler={Root}>
    <Route name="apps" handler={AppsPage} />
    <Route name="app-config" path="app-config/:appid" handler={AppConfigPage} />
    <Redirect from="/" to="apps" />
  </Route>
