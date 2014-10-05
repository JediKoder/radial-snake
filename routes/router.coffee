routeModules = [
  require "./pages"
  require "./endpoints"
]

exports.implement = (server) ->
  routeModules.forEach (module) ->
    module.route server.route.bind(server)