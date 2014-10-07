class Engine.Screen
  constructor: (@game, @assets) ->
    @creation = new Date().getTime()
    @loadsize = 0

    {@keyStates} = game

    {@width
     @height} = game.canvas

    @loadedAssets = @load?()

    if @loadsize
      @onload = _.after @loadsize, -> @loaded = yes
    else
      @loaded = yes

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

  createScreen: (Screen) ->
    new Screen @game, @loadedAssets

  Object.defineProperties @proto,
    "onload":
      get: ->
        @loadsize++
        => @onload()

      set: (onload) ->
        @__defineGetter__ "onload", -> onload