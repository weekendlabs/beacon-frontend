request = require 'superagent-bluebird-promise'

baseUrl = 'http://192.168.24.24:5000'

getOne = (id) ->
  request.get("#{baseUrl}/apps/#{id}")

getAll = ->
  request.get("#{baseUrl}/apps")

create = (appName) ->
  request
    .post("#{baseUrl}/apps")
    .send({name: appName})

module.exports = {
  getOne
  getAll
  create
}
