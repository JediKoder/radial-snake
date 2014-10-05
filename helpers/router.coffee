routeModules = [
  require "./../routes/pages"
  require "./../routes/endpoints"
]

exports.implement = (server) ->
  routeModules.forEach (module) ->
    module.route server.route.bind(server)