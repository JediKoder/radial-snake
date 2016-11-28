Hapi = require "hapi"
Pack = require "../package.json"
Permitter = require "../helpers/permitter"

exports.register = (server, options, next) ->
  server.route method: "GET", path: "/",     handler: getGame
  server.route method: "GET", path: "/test", handler: getSpecRunner

  next()

exports.register.attributes =
  name: "pages"
  version: Pack.version

getGame = (req, rep) ->
  path = "./views/game.html"
  permissions = []
  Permitter.file path, permissions, req, rep

getSpecRunner = (req, rep) ->
  path = "./views/spec_runner.html"
  permissions = []
  Permitter.file path, permissions, req, rep