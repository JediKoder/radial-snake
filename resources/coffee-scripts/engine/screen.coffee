class Engine.Screen
  constructor: (@game, @assets) ->
    {@width
     @height} = game.canvas

    {@keyStates} = game

    @creationDate = new Date
    loadsize = undefined

    Object.defineProperty this, "loadsize"
      get: ->
        loadsize
      set: (val) ->
        loadsize = val

        if loadsize
          @onload = _.after loadsize, @onload.bind(this)
          @loadedAssets = @load()
        else
          @loadedAssets = @load()
          @onload()

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