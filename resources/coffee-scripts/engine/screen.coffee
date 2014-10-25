class Engine.Screen
  constructor: (@game) ->
    @age = 0
    @creation = new Date().getTime()
    @assets = _(game.assets).clone()
    @keyStates = game.keyStates
    @layers = []

  update: (span, screenManager) ->
    @layers.forEach (layer) => 
      layer.age += span

      layer.update? span,
        # Layer Manager
        apppend: @appendLayer.bind this
        prepend: @prependLayer.bind this
        remove: @removeLayer.bind this
      ,
        screenManager

  draw: (context) ->
    @layers.forEach (layer) -> layer.draw? context

  appendLayer: (layer) ->
    @layers.push layer
    layer.initEventListeners()

  prependLayer: (layer) ->
    @layers.unshift layer
    layer.initEventListeners()

  removeLayer: (layer) ->
    @layers = _(@layers).without layer
    layer.disposeEventListeners()

  addEventListener: (event, listener, target = this) ->
    @game.addEventListener event, listener, target

  removeEventListener: (event, listener) ->
    @game.removeEventListener event, listener

  initEventListeners: ->
    @events?.forEach (event, listener) =>
      @addEventListener event, @[listener]

  disposeEventListeners: ->
    @events?.forEach (event, listener) =>
      @removeEventListener event, @[listener]

    @layers.forEach (layer) ->
      layer.disposeEventListeners()

  @::__defineGetter__ "width", ->
    @game.canvas.width

  @::__defineGetter__ "height", ->
    @game.canvas.height