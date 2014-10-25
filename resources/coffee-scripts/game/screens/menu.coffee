class Game.Screens.Menu extends Engine.Screen
  events:
    "keydown": "onKeyDown"

  initialize: ->
    @logoSprite = new Engine.Sprite @assets.logoTexture
    @logoSprite.setPercentage "width", @width, 30, "height"

    instructionsSprite = new Engine.Sprite @assets.minecraftiaFont.createTexture "Press a key to start"
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

  unload: ->
    "logoTexture"

  draw: (context) ->
    @logoSprite.draw context
    @instructionsAnim.draw context

  update: (span) ->
    if @keyPressed
      @game.changeScreen Game.Screens.Play
    else
      @instructionsAnim.update span

  onKeyDown: (e) ->
    @keyPressed = yes