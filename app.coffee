Hapi = require "hapi"
Router = require "./routes/router"

server = new Hapi.Server 8000,
  files:
    relativeTo: __dirname

Router server
server.start()