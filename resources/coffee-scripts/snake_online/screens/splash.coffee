class SnakeOnline.Screens.Splash extends Engine.Screen
  initialize: ->
    @menuScreen = new SnakeOnline.Screens.Menu @game

    splashSprite = new Engine.Sprite @assets.splashTexture
    splashSprite.align = "center"
    splashSprite.x = @width / 2

    @splashAnim = new Engine.Animations.Keyframe splashSprite, [
      y: @height / 2 - 30
      width: splashSprite.width / 4
      height: splashSprite.height / 4
      opacity: 0
      easing: "in"
      frame: 0
    ,
      y: @height / 2
      width: splashSprite.width / 3 + splashSprite.width * 0.05
      height: splashSprite.height / 3 + splashSprite.height * 0.05
      opacity: 1
      frame: 3000
    ,
      frame: 3500
    ]

    @splashAnim.playing = yes

  load: (next, assetsManager) ->
    splashTexture = new Image
    splashTexture.onload = next()
    splashTexture.src = "/textures/splash.png"

    minecraftiaFont = new Engine.Font
    minecraftiaFont.onload = next()
    minecraftiaFont.src = "/fonts/minecraftia"

    logoTexture = new Image
    logoTexture.onload = next()
    logoTexture.src = "/textures/logo.png"

    assetsManager.remember {
      minecraftiaFont
      logoTexture
    }
    
    {splashTexture}

  draw: (context) ->
    @splashAnim.draw context

  update: (span, screenManager) ->
    if @splashAnim.playing
      @splashAnim.update span
    else
      screenManager.change @menuScreen