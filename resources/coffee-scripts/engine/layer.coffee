class Engine.Layer
  constructor: (@screen) ->
    @age = 0
    @creation = new Date().getTime()
    
    {@assets
     @keyStates} = screen

  initEventListeners: ->
    @events?.forEach (event, listener) =>
      @screen.addEventListener event, @[listener], this

  disposeEventListeners: ->
    @events?.forEach (event, listener) =>
      @screen.removeEventListener event, @[listener]

  @::__defineGetter__ "width", ->
    @screen.width

  @::__defineGetter__ "height", ->
    @screen.height