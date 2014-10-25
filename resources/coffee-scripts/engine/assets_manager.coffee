class Engine.AssetsManager
  constructor: (@onload) ->

  loadTexture: (path) ->
    image = new Image
    image.onload = @onload
    image.src = "#{path}.png"
    image

  loadFont: (path) ->
    font = new Engine.Font
    font.onload = @onload
    font.src = path
    font