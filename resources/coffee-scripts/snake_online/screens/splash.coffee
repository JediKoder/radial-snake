class SnakeOnline.Screens.Splash extends Engine.Screen
  constructor: (game, assets) ->
    super game
    @load()

    splashSprite = new Engine.Sprite assets.splashTexture
    splashSprite.align = "center"
    splashSprite.location.x = @width / 2

    @splashAnim = new Engine.Animations.Keyframe splashSprite, [
      width: splashSprite.width / 4
      height: splashSprite.height / 4
      opacity: 0.4
      location: y: this.height / 2 - 30
      frame: 0
    ,
      width: splashSprite.width / 3
      height: splashSprite.height / 3
      opacity: 1
      frame: 2000
    ,
      width: splashSprite.width / 3 + splashSprite.width * 0.05
      height: splashSprite.height / 3 + splashSprite.height * 0.05
      location: y: this.height / 2
      frame: 5000
    ]

    @splashAnim.playing = yes

  draw: (context) ->
    super context
    @splashAnim.draw context

  update: (span) ->
    @splashAnim.update span

    if not @splashAnim.playing and @loaded
      new SnakeOnline.Screens.Menu @game, @assets
    else
      this

  load: ->
    loadedAssets = 0

    @assets =
      logoTexture: new Image
      instructionsFont: new Engine.Font

    _.values(@assets).forEach (v, i, values) =>
      v.onload = => 
        @loaded = yes if ++loadedAssets is values.length

      switch i
        when 0 then v.src = "/textures/logo.png"
        when 1 then v.src = "/fonts/minecraftia"