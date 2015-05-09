request = require 'superagent-bluebird-promise'

baseUrl = 'http://localhost:3000'

getAll = ->
  request.get("#{baseUrl}/apps")

module.exports = {
  getAll
}
