routeModules = [
  require "./pages"
  require "./endpoints"
]

exports.implement = (server) ->
  routeModules.forEach (module) ->
    module.routes(server).forEach (route) ->
      server.route route