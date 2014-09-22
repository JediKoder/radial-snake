SnakeOnline.Screens.Game::playState =
  initialize: ->
    @snakes = [
      new SnakeOnline.Entities.Snake(
        @width / 4
        @height / 4
        50
        Math.PI / 4
        100
        "red"
        @keyStates
        keys:
          left: 37
          right: 39
      )

      new SnakeOnline.Entities.Snake(
        @width / 4 * 3
        @height / 4 * 3
        50
        -Math.PI / 4 * 3
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
    @snakes.forEach (snake, i) =>
      snake.update span
      selfIntersection = snake.getSelfIntersection()
      console.log "self intersection" if selfIntersection?

      @snakes.forEach (rival, j) =>
        return if i is j
        snakeIntersection = snake.getSnakeIntersection rival
        console.log "snake intersection" if snakeIntersection?

    this