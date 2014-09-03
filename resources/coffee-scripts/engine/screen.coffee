class Engine.Screen
  constructor: (@game) ->
    @width = game.canvas.width
    @height = game.canvas.height
    @keyStates = game.keyStates
    @creationDate = new Date

  draw: (context) ->
    context.fillStyle = "black"
    context.beginPath()
    context.rect 0, 0, @width, @height
    context.fill()

  addEventListeners: ->
    @events?.forEach (k, v) =>
      @game.addEventListener k, @[v], this

  removeEventListeners: ->
    @events?.forEach (k, v) =>
      @game.removeEventListener k, @[v]