class SnakeOnline.Screens.Play extends Engine.Screen
  @Layers = {}

  initialize: ->
    @appendLayer new Play.Layers.Ready this