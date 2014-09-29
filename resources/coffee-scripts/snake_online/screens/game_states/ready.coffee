SnakeOnline.Screens.Game::readyState =
  events:
    "keydown": "onKeyDown"

  initialize: -> 
    @readySprite.align = "center"
    @readySprite.setPercentage "width", @width, 15, "height"
    @readySprite.location = x: @width / 2, y: @height / 2

  draw: (context) ->
    @readySprite.draw context

  update: (span) ->
    return on unless @ready
    @prependState "play"
    off

  onKeyDown: ->
    @ready = yes