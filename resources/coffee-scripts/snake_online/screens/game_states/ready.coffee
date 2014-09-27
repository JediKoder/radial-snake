SnakeOnline.Screens.Game::readyState =
  events:
    "keydown": "onKeyDown"

  initialize: -> 
    @readySprite = new Engine.Sprite @minecraftiaFont.createTexture "Ready"
    @readySprite.align = "center"
    @readySprite.setPercentage "width", @width, 15, "height"
    @readySprite.location = x: @width / 2, y: @height / 2

  draw: (context) ->
    @readySprite.draw context

  update: (span) ->
    @setState "play" if @ready
    this

  onKeyDown: ->
    @ready = yes