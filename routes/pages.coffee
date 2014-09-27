Hapi = require "hapi"
Permitter = require "./../helpers/permitter"

exports.routes = -> [
  { method: "GET", path: "/", handler: getGame }
  { method: "GET", path: "/test", handler: getSpecRunner }
]

getGame = (req, rep) ->
  file = "./views/game.html"
  permissions = []
  Permitter.page file, permissions, req, rep

getSpecRunner = (req, rep) ->
  file = "./views/spec_runner.html"
  permissions = []
  Permitter.page file, permissions, req, rep