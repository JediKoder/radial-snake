class SnakeOnline.Screens.Play.Layers.Ready extends Engine.Layer
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

  update: (span, layerManager) ->
    return unless @ready

    if @screen.layers.length is 1
      @readyAnim.playing = yes
      layerManager.prepend new SnakeOnline.Screens.Play.Layers.Snake @screen
    else if @readyAnim.playing
      @readyAnim.update span
    else
      layerManager.remove this

  onKeyDown: ->
    @ready = yes