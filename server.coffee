Async = require "async"
Hapi = require "hapi"
Inert = require "inert"
Endpoints = require "./routes/endpoints"
IpGrabber = require "./helpers/ip_grabber"
Pages = require "./routes/pages"

localIp = IpGrabber.local()
port = 8000

server = new Hapi.Server
  connections:
    routes:
      files:
        relativeTo: __dirname

server.connection { port: process.env.PORT || port }

server.ext "onPreResponse", (req, next) ->
  res = req.response
  console.log "Outcoming response:"
  console.log "in: #{new Date}"
  console.log "to: #{req.info.remoteAddress}"
  console.log "method: #{req.method}"
  console.log "url: #{req.url.path}"
  console.log "status: #{res.statusCode || res.output.statusCode}"
  console.log()
  next()

Async.series [
  (next) -> server.register Inert, next
  (next) -> server.register Endpoints, next
  (next) -> server.register Pages, next
  (next) -> server.start next
], (err) ->
  throw err if err

  console.log()
  console.log "---------- -------- ------ ---- --"
  console.log "----- ---- --- -- -"
  console.log "Server running at #{localIp}:#{port}"
  console.log "----- ---- --- -- -"
  console.log "---------- -------- ------ ---- --"
  console.log()