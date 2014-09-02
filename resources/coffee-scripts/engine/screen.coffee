class Engine.Screen
  constructor: (@game) ->
    @width = game.canvas.width
    @height = game.canvas.height
    @keyStates = game.keyStates

  draw: (context) ->
    context.fillStyle = "black"
    context.beginPath()
    context.rect 0, 0, @width, @height
    context.fill()