class SnakeOnline.Screens.Menu extends Engine.Screen
  events:
    "keydown": "onKeyDown"

  constructor: (game, assets) ->
    super game, assets
    @logoSprite = new Engine.Sprite @logoTexture
    @logoSprite.setPercentage "width", @width, 30, "height"

    instructionsSprite = new Engine.Sprite @minecraftiaFont.createTexture "Press a key to start"
    instructionsSprite.align = "center"
    instructionsSprite.setPercentage "width", @width, 35, "height"
    instructionsSprite.location = x: @width / 2, y: @height / 2

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
    super context
    @logoSprite.draw context
    @instructionsAnim.draw context

  update: (span) ->
    if @keyPressed
      new SnakeOnline.Screens.Game @game, {@minecraftiaFont}

    else
      @instructionsAnim.update span
      this

  onKeyDown: (e) ->
    @keyPressed = yes
