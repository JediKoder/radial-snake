SnakeOnline.Screens.Game::playState =
  initialize: ->
    @snake = new SnakeOnline.Entities.Snake(
      @width / 2
      @height / 2
      50
      0
      100
      "red"
      @keyStates
    )

  draw: (context) ->
    @snake.draw context

  update: (span) ->
    @snake.update span
    this