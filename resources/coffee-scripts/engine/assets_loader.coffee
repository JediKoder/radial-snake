class Engine.AssetsLoader
  constructor: (@onload) ->

  texture: (path) ->
    image = new Image
    image.onload = @onload
    image.src = "#{path}.png"
    image

  font: (path) ->
    font = new Engine.Font
    font.onload = @onload
    font.src = path
    font