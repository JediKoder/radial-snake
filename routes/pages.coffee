Hapi = require "hapi"
Os = require "os"

getGame = (req, rep) ->
  rep.file "./views/game.html"

getSpecRunner = (req, rep) ->
  permitted = [
    getLocalIp()
  ]

  if permitted.indexOf(req.info.removeAddress) != -1
    error = Hapi.error.forbidden "Missing permissions"
    error.output.statusCode = 403
    error.reformat()
    rep error
  else
    rep.file "./views/spec_runner.html"

getLocalIp = ->
  interfaces = Os.networkInterfaces()
  addresses = []

  for k of interfaces
    for k2 of interfaces[k]
      address = interfaces[k][k2]
      if address.family is "IPv4" and not address.internal
        addresses.push address.address

  addresses

module.exports = [
  { method: "GET", path: "/", handler: getGame }
  { method: "GET", path: "/test", handler: getSpecRunner }
]