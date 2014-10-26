class Engine.AssetsLoader
  constructor: (@next) ->

  texture: (path) ->
    image = new Image
    image.onload = @next()
    image.src = "#{path}.png"
    image

  font: (path) ->
    font = new Engine.Font
    font.onload = @next()
    font.src = path
    font