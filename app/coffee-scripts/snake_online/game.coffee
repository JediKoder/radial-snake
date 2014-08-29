class SnakeOnline.Game
  fps: 60
  speed: 1

  constructor: (@canvas, @debugging) ->
    canvas.width = 1280
    canvas.height = 720
    canvas.focus()

    canvas.addEventListener "mousedown", canvas.focus, false
    canvas.addEventListener "keydown", ((e) -> e.preventDefault()), false

    @context = canvas.getContext "2d"
    @bufferedCanvas = document.createElement "canvas"
    @bufferedContext = @bufferedCanvas.getContext "2d"
    @bufferedCanvas.width = canvas.width
    @bufferedCanvas.height = canvas.height
    @screen = new SnakeOnline.Screens.SplashLoading this
    @lastUpdate = new Date
    @events = []

  draw: ->
    if @debugging
      @context.restore()
      @context.fillStyle = "white"
      @context.save()
      @context.beginPath()
      @context.rect 0, 0, @canvas.width, @canvas.height
      @context.fill()
      @screen.draw @context
    else
      @bufferedContext.restore()
      @bufferedContext.fillStyle = "white"
      @bufferedContext.save()
      @bufferedContext.beginPath()
      @bufferedContext.rect 0, 0, @canvas.width, @canvas.height
      @bufferedContext.fill()
      @screen.draw @bufferedContext
      @context.drawImage @bufferedCanvas, 0, 0

  update: ->
    lastUpdate = @lastUpdate
    currUpdate = @lastUpdate = new Date
    span = currUpdate.getTime() - lastUpdate.getTime()
    @screen = @screen.update span / @speed

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

  addEventListener: (type, listener, target) ->
    bindedListener = listener.bind target

    @events.push
      listener: listener
      bindedListener: bindedListener

    @canvas.addEventListener type, bindedListener, false

  removeEventListener: (type, listener) ->
    event = _.find @events, (e) ->
      e.listener is listener

    @events = _.without @events, event
    @canvas.removeEventListener type, event.bindedListener, false