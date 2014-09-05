class SnakeOnline.Screens.SplashLoading extends Engine.Screen
  constructor: (game) ->
    super game
    @load()

  update: (span) ->
    if @loaded
      new SnakeOnline.Screens.Splash @game, @assets
    else
      this

  load: ->
    splashTexture = new Image

    splashTexture.onload = =>
      @assets = {splashTexture}
      @loaded = yes

    splashTexture.src = "/textures/splash.png"