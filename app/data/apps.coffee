request = require 'superagent-bluebird-promise'

# baseUrl = 'http://192.168.24.24:3000'
baseUrl = 'http://localhost:3000'

getOne = (id) ->
  request.get("#{baseUrl}/apps/#{id}")

getAll = ->
  request.get("#{baseUrl}/apps")

putConfig = (id, config) ->
  request
    .put("#{baseUrl}/apps/#{id}")
    .send(config: config)

create = (appName) ->
  request
    .post("#{baseUrl}/apps")
    .send({name: appName})

deploy = (id) ->
  request
    .post("#{baseUrl}/deploy/#{id}")

module.exports = {
  getOne
  getAll
  putConfig
  create
  deploy
}
