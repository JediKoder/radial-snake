class SnakeOnline.Game
  fps: 60
  speed: 1

  constructor: (@canvas, Screen, @debugging) ->
    canvas.width = 1280
    canvas.height = 720
    canvas.focus()

    canvas.addEventListener "mousedown", canvas.focus, no
    canvas.addEventListener "keydown", @onKeyDown.bind(this), no
    canvas.addEventListener "keyup", @onKeyUp.bind(this), no

    @events = []
    @screens = []
    @context = canvas.getContext "2d"
    @bufferedCanvas = doc.createElement "canvas"
    @bufferedContext = @bufferedCanvas.getContext "2d"
    @bufferedCanvas.width = canvas.width
    @bufferedCanvas.height = canvas.height
    @keyStates = new Engine.KeyStates
    @appendScreen new Screen this
    @lastUpdate = new Date().getTime()

  draw: ->
    if @debugging
      @context.restore()
      @context.fillStyle = "white"
      @context.save()
      @context.beginPath()
      @context.rect 0, 0, @canvas.width, @canvas.height
      @context.fill()
      @drawScreens @context
    else
      @bufferedContext.restore()
      @bufferedContext.fillStyle = "white"
      @bufferedContext.save()
      @bufferedContext.beginPath()
      @bufferedContext.rect 0, 0, @canvas.width, @canvas.height
      @bufferedContext.fill()
      @drawScreens @bufferedContext
      @context.drawImage @bufferedCanvas, 0, 0

  drawScreens: (context) ->
    context.fillStyle = "black"
    context.beginPath()
    context.rect 0, 0, @canvas.width, @canvas.height
    context.fill()

    @screens.forEach (screen) ->
      screen.draw? context

  update: ->
    lastUpdate = @lastUpdate
    currUpdate = @lastUpdate = new Date().getTime()
    span = currUpdate - lastUpdate
    @updateScreens span / @speed

  updateScreens: (span) ->
    @screens.forEach (screen) ->
      screen.age = @lastUpdate - screen.creation
      screen.update? span

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

  appendScreen: (screen) ->
    @screens.push screen
    screen.addEventListeners()

  prependScreen: (screen) ->
    @screens.unshift screen
    screen.addEventListeners()

  removeScreen: (screen) ->
    @screens = _(@screens).without screen
    screen.removeEventListeners()

  addEventListener: (type, listener, target) ->
    bindedListener = listener.bind target

    @events.push
      listener: listener
      bindedListener: bindedListener

    @canvas.addEventListener type, bindedListener, no

  removeEventListener: (type, listener) ->
    event = _.find @events, (e) ->
      e.listener is listener

    @events = _.without @events, event
    @canvas.removeEventListener type, event.bindedListener, no

  onKeyDown: (e) ->
    e.preventDefault()
    @keyStates.add e.keyCode

  onKeyUp: (e) ->
    e.preventDefault()
    @keyStates.remove e.keyCode