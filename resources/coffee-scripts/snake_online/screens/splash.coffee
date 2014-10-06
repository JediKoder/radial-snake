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
      opacity: 0
      easing: "in"
      frame: 0
    ,
      y: this.height / 2
      width: splashSprite.width / 3 + splashSprite.width * 0.05
      height: splashSprite.height / 3 + splashSprite.height * 0.05
      opacity: 1
      frame: 3000
    ,
      frame: 3500
    ]

    @splashAnim.playing = yes

  draw: (context) ->
    @splashAnim.draw context

  update: (span) ->
    @splashAnim.update span
    return if @splashAnim.playing or not @loaded
      
    @appendScreen SnakeOnline.Screens.Menu
    @remove()

  load: ->
    logoTexture = new Image
    logoTexture.onload = @onload
    logoTexture.src = "/textures/logo.png"

    minecraftiaFont = new Engine.Font
    minecraftiaFont.onload = @onload
    minecraftiaFont.src = "/fonts/minecraftia"

    {logoTexture, minecraftiaFont}