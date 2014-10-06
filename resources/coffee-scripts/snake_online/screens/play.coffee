class SnakeOnline.Screens.Play extends Engine.Screen
  constructor: (game, assets) ->
    super game, assets
    @loadedAssets = assets

    @snakes = [
      new SnakeOnline.Entities.Snake(
        @width / 4
        @height / 4
        50
        Math.PI / 4
        100
        "FireBrick"
        @keyStates
        keys:
          left: 37 # left
          right: 39 # right
      )

      new SnakeOnline.Entities.Snake(
        @width / 4 * 3
        @height / 4 * 3
        50
        -Math.PI / 4 * 3
        100
        "DodgerBlue"
        @keyStates
        keys:
          left: 65 # a
          right: 68 # d
      )
    ]

    @appendScreen SnakeOnline.Screens.Score, @snakes

  draw: (context) ->
    @snakes.forEach (snake) ->
      snake.draw context

  update: (span) ->
    disqualifiedIndexes = []

    @snakes.forEach (snake, i) =>
      snake.update span
      selfIntersection = snake.getSelfIntersection()
      disqualifiedIndexes.push i if selfIntersection?

      @snakes.forEach (rival, j) =>
        return if i is j
        snakeIntersection = snake.getSnakeIntersection rival
        disqualifiedIndexes.push i if snakeIntersection?

    disqualifiedIndexes.forEach (index) =>
      @snakes.splice index, 1
      if @snakes.length is 1
        @snakes[0].score++