class SnakeOnline.Screens.Play extends Engine.Screen
  @Layers = {}

  initialize: ->
    @appendLayer Play.Layers.Ready