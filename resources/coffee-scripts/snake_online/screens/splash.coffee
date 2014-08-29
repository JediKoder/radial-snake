class SnakeOnline.Screens.Splash extends Engine.Screen
  constructor: (game, assets) ->
    super game
    @load()

    splashTexture = assets.splashTexture

    @splashAnim = new Engine.Animations.Keyframe splashTexture, [
      width: splashTexture.width / 4
      height: splashTexture.height / 4
      opacity: 0.4
      location: y: this.height / 2 - 30
      frame: 0
    ,
      width: splashTexture.width / 3
      height: splashTexture.height / 3
      opacity: 1
      frame: 2000
    ,
      width: splashTexture.width / 3 + splashTexture.width * 0.05
      height: splashTexture.height / 3 + splashTexture.height * 0.05
      location: y: this.height / 2
      frame: 5000
    ],
      align: "center"
      location: x: @width / 2

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
      instructionsTexture: new Image

    _.values(@assets).forEach (v, i, values) =>
      v.onload = => 
        @loaded = yes if ++loadedAssets is values.length

      switch i
        when 0 then v.src = "/textures/logo.png"
        when 1 then v.src = "/textures/menu/instructions.png"