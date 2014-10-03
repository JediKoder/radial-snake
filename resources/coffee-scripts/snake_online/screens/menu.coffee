class SnakeOnline.Screens.Menu extends Engine.Screen
  events:
    "keydown": "onKeyDown"

  constructor: (game, assets) ->
    super game, assets
    @loadedAssets = assets

    @logoSprite = new Engine.Sprite assets.logoTexture
    @logoSprite.setPercentage "width", @width, 30, "height"

    instructionsSprite = new Engine.Sprite assets.minecraftiaFont.createTexture "Press a key to start"
    instructionsSprite.align = "center"
    instructionsSprite.setPercentage "width", @width, 35, "height"
    instructionsSprite.x = @width / 2
    instructionsSprite.y = @height / 2

    @instructionsAnim = new Engine.Animations.Keyframe instructionsSprite, [
      opacity: 1
      frame: 0
    ,
      opacity: 0
      frame: 2000
    ]

    @instructionsAnim.repMode = "full"
    @instructionsAnim.playing = yes

  draw: (context) ->
    @logoSprite.draw context
    @instructionsAnim.draw context

  update: (span) ->
    if @keyPressed
      @appendScreen SnakeOnline.Screens.Ready
      off
    else
      @instructionsAnim.update span
      on

  onKeyDown: (e) ->
    @keyPressed = yes