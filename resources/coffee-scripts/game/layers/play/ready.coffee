class Game.Layers.Play.Ready extends Engine.Layer
  events:
    "keydown": "onKeyDown"

  constructor: (screen) ->
    super screen

    readySprite = new Engine.Sprite @assets.minecraftiaFont.createTexture "Ready"
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
    return unless @ready

    if @readyAnim.playing
      @readyAnim.update span
    else
      @screen.removeLayer this

  onKeyDown: ->
    @ready = yes
    @readyAnim.playing = yes
    @screen.prependLayer Game.Layers.Play.Snake