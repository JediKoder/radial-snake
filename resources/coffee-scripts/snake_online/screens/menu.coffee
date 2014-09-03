class SnakeOnline.Screens.Menu extends Engine.Screen
  events:
    "keydown": "onKeyDown"

  constructor: (game, assets) ->
    super game
    @logoSprite = new Engine.Sprite assets.logoTexture
    @logoSprite.setPercentage "width", @width, 30, "height"

    @instructionsAnim = new Engine.Animations.Keyframe assets.instructionsTexture, [
      opacity: 1
      frame: 0
    ,
      opacity: 0
      frame: 2000
    ],
      align: "center"
      setPercentage: ["width", @width, 35, "height"]
      location: x: @width / 2, y: @height / 2

    @instructionsAnim.repMode = "full"
    @instructionsAnim.playing = true
    @addEventListeners()

  draw: (context) ->
    super context
    @logoSprite.draw context
    @instructionsAnim.draw context

  update: (span) ->
    if @keyPressed
      @removeEventListeners()
      new SnakeOnline.Screens.Game @game
    else
      @instructionsAnim.update span
      this

  onKeyDown: (e) ->
    @keyPressed = true
