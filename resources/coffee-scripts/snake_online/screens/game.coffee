class SnakeOnline.Screens.Game extends Engine.Screens.Statable
  states:
    "ready": "readyState"
    "play": "playState"

  constructor: (game, state) ->
    super game, state
    @readyText = new Engine.Text "READY", "50pt Minecraftia"
    @readyText.location = x: @width / 2, y: @height / 2
    @readyText.align = "center"
    @readyText.color = "white"