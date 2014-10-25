class Engine.Game
  fps: 60
  speed: 1

  constructor: (@canvas, @debugging) ->
    @lastUpdate = @creation = new Date().getTime()

    canvas.width = 1280
    canvas.height = 720
    canvas.focus()

    canvas.addEventListener "mousedown", canvas.focus, no
    canvas.addEventListener "keydown", onKeyDown.bind(this), no
    canvas.addEventListener "keyup", onKeyUp.bind(this), no

    @assets = {}
    @events = new Map
    @context = canvas.getContext "2d"
    @bufferedCanvas = doc.createElement "canvas"
    @bufferedContext = @bufferedCanvas.getContext "2d"
    @bufferedCanvas.width = canvas.width
    @bufferedCanvas.height = canvas.height
    @keyStates = new Engine.KeyStates

  draw: ->
    if @debugging
      @context.restore()
      @context.fillStyle = "black"
      @context.save()
      @context.beginPath()
      @context.rect 0, 0, @canvas.width, @canvas.height
      @context.fill()
      @drawScreen @context
    else
      @bufferedContext.restore()
      @bufferedContext.fillStyle = "black"
      @bufferedContext.save()
      @bufferedContext.beginPath()
      @bufferedContext.rect 0, 0, @canvas.width, @canvas.height
      @bufferedContext.fill()
      @drawScreen @bufferedContext
      @context.drawImage @bufferedCanvas, 0, 0

  drawScreen: (context) ->
    return if @screen.loading
    @screen.draw? context

  update: ->
    lastUpdate = @lastUpdate
    currUpdate = @lastUpdate = new Date().getTime()
    span = currUpdate - lastUpdate
    @updateScreen span / @speed

  updateScreen: (span) ->
    @screen.age += span
    return if @screen.loading
    @screen.update? span

  loop: ->
    return unless @playing

    setTimeout =>
      @draw()
      @update()
      @loop()
    , @fps

  play: ->
    @playing = yes
    @loop()

  pause: ->
    @playing = no

  changeScreen: (Screen, screenArgs...) ->
    if @screen
      @unloadScreen()
      @screen.disposeEventListeners()

    @screen = new Screen this, screenArgs...

    @loadScreen =>
      @screen.initEventListeners()
      @screen.initialize()

  loadScreen: (callback) ->
    return callback?() unless @screen.load?

    @screen.loading = yes
    loadsize = 0

    _(@screen.assets).extend @screen.load =>
      loadsize++
      => onload()

    onload = _.after loadsize, =>
      delete @screen.loading
      callback?()

  unloadScreen: ->
    _(@assets).omit @screen.unload?()

  extendAssets: (assets) ->
    _(@assets).extend assets

  clearAssets: ->
    @assets = {}

  addEventListener: (type, listener, target) ->
    boundListener = listener.bind target
    @events.set listener, boundListener
    @canvas.addEventListener type, boundListener, no

  removeEventListener: (type, listener) ->
    boundListener = @events.get listener
    @events.delete listener
    @canvas.removeEventListener type, boundListener, no

  onKeyDown = (e) ->
    e.preventDefault()
    @keyStates.add e.keyCode

  onKeyUp = (e) ->
    e.preventDefault()
    @keyStates.remove e.keyCode