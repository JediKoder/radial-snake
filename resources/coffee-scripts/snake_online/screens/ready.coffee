class SnakeOnline.Screens.Ready extends Engine.Screen
  events:
    "keydown": "onKeyDown"

  constructor: (game, assets) ->
    super game, assets
    readySprite = new Engine.Sprite assets.minecraftiaFont.createTexture "Ready"
    readySprite.align = "center"
    readySprite.setPercentage "width", @width, 15, "height"

    @readyAnim = new Engine.Animations.Keyframe readySprite, [
      x: @width / 2
      y: @height / 2
      opacity: 1
      frame: 0
    ,
      y: @height / 3
      opacity: 0
      frame: 700
    ]

  draw: (context) ->
    @readyAnim.draw context

  update: (span) ->
    unless @ready
      on
    else if @game.screens.length is 1
      @readyAnim.playing = yes
      @prependScreen SnakeOnline.Screens.Play
      on
    else if @readyAnim.playing
      @readyAnim.update span
      on
    else
      off

  onKeyDown: ->
    @ready = yes