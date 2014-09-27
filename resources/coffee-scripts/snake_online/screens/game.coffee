class SnakeOnline.Screens.Game extends Engine.Screens.Statable
  states:
    "ready": "readyState"
    "play": "playState"

  constructor: (game, state, @assets) ->
    super game, state