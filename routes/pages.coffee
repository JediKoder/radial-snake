Hapi = require "hapi"
Permitter = require "./../helpers/permitter"

getGame = (req, rep) ->
  file = "./views/game.html"
  permissions = []
  Permitter.page file, permissions, req, rep

getSpecRunner = (req, rep) ->
  file = "./views/game.html"
  permissions = []
  Permitter.page file, permissions, req, rep

module.exports = [
  { method: "GET", path: "/", handler: getGame }
  { method: "GET", path: "/test", handler: getSpecRunner }
]