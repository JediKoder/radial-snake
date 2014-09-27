SnakeOnline.Screens.Game::readyState =
  events:
    "keydown": "onKeyDown"

  initialize: -> 
    @readyText = new Engine.Sprites.Text "Ready", @assets.readyFont
    @readyText.align = "center"
    @readyText.setPercentage "width", @width, 20, "height"
    @readyText.location = x: @width / 2, y: @height / 2

  draw: (context) ->
    @readyText.draw context

  update: (span) ->
    @setState "play" if @ready
    this

  onKeyDown: ->
    @ready = yes