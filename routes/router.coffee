routeModules = [
  require "./endpoints"
  require "./pages"
]

module.exports = (server) ->
  routeModules.forEach (routes) ->
    routes.forEach (route) ->
      server.route route