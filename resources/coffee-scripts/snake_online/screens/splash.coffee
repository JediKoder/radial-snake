class SnakeOnline.Screens.Splash extends Engine.Screen
  constructor: (game, assets) ->
    super game, assets
    @loadsize = 2

    splashSprite = new Engine.Sprite assets.splashTexture
    splashSprite.align = "center"
    splashSprite.x = @width / 2

    @splashAnim = new Engine.Animations.Keyframe splashSprite, [
      y: this.height / 2 - 30
      width: splashSprite.width / 4
      height: splashSprite.height / 4
      opacity: 0.4
      frame: 0
    ,
      width: splashSprite.width / 3
      height: splashSprite.height / 3
      opacity: 1
      frame: 2000
    ,
      y: this.height / 2
      width: splashSprite.width / 3 + splashSprite.width * 0.05
      height: splashSprite.height / 3 + splashSprite.height * 0.05
      frame: 5000
    ]

    @splashAnim.playing = yes

  draw: (context) ->
    @splashAnim.draw context

  update: (span) ->
    @splashAnim.update span

    if not @splashAnim.playing and @loaded
      @appendScreen SnakeOnline.Screens.Menu
      off
    else
      on

  load: ->
    logoTexture = new Image
    logoTexture.onload = @onload
    logoTexture.src = "/textures/logo.png"

    minecraftiaFont = new Engine.Font
    minecraftiaFont.onload = @onload
    minecraftiaFont.src = "/fonts/minecraftia"

    {logoTexture, minecraftiaFont}