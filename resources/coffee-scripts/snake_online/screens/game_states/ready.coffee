SnakeOnline.Screens.Game::readyState =
  events:
    "keydown": "onKeyDown"

  draw: (context) ->
    @readyText.draw context

  update: (span) ->
    @setState "play" if @ready
    this

  onKeyDown: ->
    @ready = yes