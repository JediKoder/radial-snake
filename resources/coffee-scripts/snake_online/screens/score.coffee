class SnakeOnline.Screens.Score extends Engine.Screen
  constructor: (game, assets, @snakes) ->
    super game, assets
    @scoreSprites = []
    @scores = []

    snakes.forEach (snake, i) ->
      snake.index = i

  draw: (context) ->
    @scoreSprites.forEach (scoreSprite) ->
      scoreSprite.draw context

  update: (span) ->
    @snakes.forEach (snake) =>
      i = snake.index
      return if @scores[i] is snake.score
      @scoreSprites[i] = @createScoreSprite snake, i
      @scores[i] = snake.score

  createScoreSprite: (snake, i) ->
    minecraftiaFont = @assets.minecraftiaFont
    minecraftiaFont.save()
    minecraftiaFont.color = snake.color

    sprite = new Engine.Sprite minecraftiaFont.createTexture "#{snake.score}",
      noOffsets: true
      noSpaces: true

    sprite.setPercentage "width", @width, 4, "height"

    switch snake.index
      when 0
        sprite.align = "top-left"
      when 1
        sprite.align = "top-right"
        sprite.x = @width

    minecraftiaFont.restore()
    sprite