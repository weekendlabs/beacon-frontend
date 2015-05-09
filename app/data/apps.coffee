request = require 'superagent-bluebird-promise'

baseUrl = 'http://localhost:3000'

getOne = (id) ->
  request.get("#{baseUrl}/apps/#{id}")

getAll = ->
  request.get("#{baseUrl}/apps")

putConfig = (id, config) ->
  console.log config
  request
    .put("#{baseUrl}/apps/#{id}")
    .send(config: config)

create = (appName) ->
  request
    .post("#{baseUrl}/apps")
    .send({name: appName})

module.exports = {
  getOne
  getAll
  putConfig
  create
}
