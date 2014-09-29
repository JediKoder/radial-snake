class SnakeOnline.Screens.Game extends Engine.Screens.Statable
  states:
    "ready": "readyState"
    "play": "playState"

  constructor: (game, assets) ->
    super game, assets
    @readySprite = new Engine.Sprite @minecraftiaFont.createTexture "Ready"
    @appendState "ready"