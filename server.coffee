Hapi = require "hapi"
Router = require "./routes/router"
IpGrabber = require "./helpers/ip_grabber"

localIp = IpGrabber.local()
port = 8000

server = new Hapi.Server port,
  files:
    relativeTo: __dirname

console.log()
console.log "---------- -------- ------ ---- --"
console.log "----- ---- --- -- -"
console.log "starting server on #{localIp}:#{port}"
console.log "----- ---- --- -- -"
console.log "---------- -------- ------ ---- --"
console.log()

Router server
server.start()