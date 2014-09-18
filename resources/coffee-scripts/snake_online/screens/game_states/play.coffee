SnakeOnline.Screens.Game::playState =
  initialize: ->
    @snakes = [
      new SnakeOnline.Entities.Snake(
        @width / 2 - @width / 3
        @height / 2
        50
        0
        100
        "red"
        @keyStates
        keys:
          left: 37
          right: 39
      )

      new SnakeOnline.Entities.Snake(
        @width / 2 + @width / 3
        @height / 2
        50
        Math.PI
        100
        "azure"
        @keyStates
        keys:
          left: 65
          right: 68
      )
    ]

  draw: (context) ->
    @snakes.forEach (snake) ->
      snake.draw context

  update: (span) ->
    @snakes.forEach (snake) ->
      snake.update span

    this