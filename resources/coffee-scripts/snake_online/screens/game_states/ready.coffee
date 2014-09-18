SnakeOnline.Screens.Game::readyState =
  events:
    "keydown": "onKeyDown"

  initialize: -> 
    @readyText = new Engine.Text "READY", "50pt Minecraftia"
    @readyText.location = x: @width / 2, y: @height / 2
    @readyText.align = "center"
    @readyText.color = "white"

  draw: (context) ->
    @readyText.draw context

  update: (span) ->
    @setState "play" if @ready
    this

  onKeyDown: ->
    @ready = yes