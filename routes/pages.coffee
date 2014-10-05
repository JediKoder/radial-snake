Hapi = require "hapi"
Permitter = require "./../helpers/permitter"

exports.route = (route) ->
  route method: "GET", path: "/",     handler: getGame
  route method: "GET", path: "/test", handler: getSpecRunner

getGame = (req, rep) ->
  path = "./views/game.html"
  permissions = []
  Permitter.file path, permissions, req, rep

getSpecRunner = (req, rep) ->
  path = "./views/spec_runner.html"
  permissions = []
  Permitter.file path, permissions, req, rep