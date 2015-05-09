K = require 'kefir'
request = require 'superagent-bluebird-promise'

# baseUrl = 'http://192.168.24.24:3000'
baseUrl = 'http://localhost:3000'

getRandomArbitrary = (min, max) ->
    return Math.random() * (max - min) + min

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

statsStream = (id) ->
  K.fromPoll(1000, ->
    m: getRandomArbitrary(20, 50)
    n: "#{getRandomArbitrary(0, 1024).toFixed()}k"
    c: getRandomArbitrary(30, 50)
  )

module.exports = {
  getOne
  getAll
  putConfig
  create
  deploy
  statsStream
}
