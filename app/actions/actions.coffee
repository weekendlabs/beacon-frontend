Reflux = require 'reflux'

actions =
  Reflux.createActions
    setNavbarChildren: {asyncResult: false}
    removeNavbarChildren: {asyncResult: false}

module.exports = actions
