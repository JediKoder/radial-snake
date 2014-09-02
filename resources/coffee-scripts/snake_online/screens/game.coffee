# TODO: Create StatableScreen parent class
class SnakeOnline.Screens.Game extends Engine.Screen
  constructor: (game) ->
    super game
    @readyText = new Engine.Text "READY", "50pt Minecraftia"
    @readyText.location = x: @width / 2, y: @height / 2
    @readyText.align = "center"
    @readyText.color = "white"
    @setState "ready"

  draw: (context) ->
    super context

    switch @state
      when "ready" then @drawReady context
      when "play" then break

  update: (span) ->
    switch @state
      when "ready" then @updateReady span
      when "play" then break

  setState: (state) ->
    switch @state
      when "ready" then @setReadyState()
      when "play" then break

    switch state
      when "ready" then @unsetReadyState()
      when "play" then break

    @state = state

  ###
  READY
  ###

  drawReady: (context) ->
    @readyText.draw context

  updateReady: (span) ->
    @setState "play" if @ready
    this

  setReadyState: ->
    @game.removeEventListener "keydown", @onReadyKeyDown

  unsetReadyState: ->
    @game.addEventListener "keydown", @onReadyKeyDown, this

  onReadyKeyDown: ->
    @ready = yes

  ###
  PLAY
  ###