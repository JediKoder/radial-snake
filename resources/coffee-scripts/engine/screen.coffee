class Engine.Screen
  constructor: (@game, assets) ->
    _.extend this, assets

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
    @events?.forEach (event) =>
      @game.addEventListener event, @getEventListener(event), this

  removeEventListeners: ->
    @events?.forEach (event) =>
      @game.removeEventListener event, @getEventListener(event)

  getEventListener: (event) ->
    listener = @events[event]

    if typeof listener is "function"
      listener
    else
      @[listener]