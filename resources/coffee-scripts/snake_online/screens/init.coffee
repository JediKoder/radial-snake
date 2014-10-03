class SnakeOnline.Screens.Init extends Engine.Screen
  constructor: (game) ->
    super game
    @loadsize = 1

  update: (span) ->
    if @loaded
      @appendScreen SnakeOnline.Screens.Splash
      off
    else
      on

  load: ->
    splashTexture = new Image
    splashTexture.onload = @onload
    splashTexture.src = "/textures/splash.png"

    {splashTexture}