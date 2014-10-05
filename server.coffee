Hapi = require "hapi"
Router = require "./routes/router"
IpGrabber = require "./helpers/ip_grabber"

localIp = IpGrabber.local()
port = 8000

server = new Hapi.Server port,
  files:
    relativeTo: __dirname

Router.implement server

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

server.start ->
  console.log()
  console.log "---------- -------- ------ ---- --"
  console.log "----- ---- --- -- -"
  console.log "Starting server at #{localIp}:#{port}"
  console.log "----- ---- --- -- -"
  console.log "---------- -------- ------ ---- --"
  console.log()