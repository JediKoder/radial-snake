class SnakeOnline.Screens.Init extends Engine.Screen
  constructor: (game) ->
    super game
    @loadsize = 1

  update: (span) ->
    return unless @loaded
    @appendScreen SnakeOnline.Screens.Splash
    @remove()

  load: ->
    splashTexture = new Image
    splashTexture.onload = @onload
    splashTexture.src = "/textures/splash.png"

    {splashTexture}