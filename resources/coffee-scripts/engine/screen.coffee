class Engine.Screen
  constructor: (@game, @assets) ->
    @creation = new Date().getTime()
    {@keyStates} = game

    {@width
     @height} = game.canvas

  appendScreen: (Screen, screenArgs...) ->
    screen = new Screen @game, @loadedAssets, screenArgs...
    @game.appendScreen screen

  prependScreen: (Screen, screenArgs...) ->
    screen = new Screen @game, @loadedAssets, screenArgs...
    @game.prependScreen screen

  remove: ->
    @game.removeScreen this

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

  onload: ->
    @loaded = yes

  createScreen: (Screen) ->
    new Screen @game, @loadedAssets

  @::__defineSetter__ "loadsize", (loadsize) ->
    @__defineGetter__ "loadsize", -> loadsize

    if loadsize
      @onload = _.after loadsize, @onload.bind(this)
      @loadedAssets = @load()
    else
      @loadedAssets = @load()
      @onload()