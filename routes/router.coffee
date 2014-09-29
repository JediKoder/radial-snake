routeModules = [
  require "./pages"
  require "./endpoints"
]

# TODO: Log each request
exports.implement = (server) ->
  routeModules.forEach (module) ->
    module.routes(server).forEach (route) ->
      server.route route