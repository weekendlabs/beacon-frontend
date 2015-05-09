K = require 'kefir'
R = require 'ramda'
request = require 'superagent-bluebird-promise'

baseUrl = 'http://192.168.24.24:3000'
#baseUrl = 'http://localhost:3000'

io = require('socket.io-client')(baseUrl)
runningContainers = []

io.on 'connect', -> console.log 'connected'

socketContainerEventStream = K.stream((emitter) ->
  io.on 'container-event', (data) ->
    emitter.emit(data)
    runningContainers =
      if data.status is 'start' then R.append(data.id, runningContainers)
      else if data.status is 'stop' then R.remove(R.findIndex(R.propEq('id', data.id)), 1, runningContainers)
      else runningContainers
)

socketStatsStream = K.stream((emitter) ->
  io.on 'stat', (data) ->
    console.log data
    emitter.emit(data)
)

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
  socketStatsStream

containerEventStream = (id) ->
  socketContainerEventStream

module.exports = {
  getOne
  getAll
  putConfig
  create
  deploy
  statsStream
  containerEventStream
}
