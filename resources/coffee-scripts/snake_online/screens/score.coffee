class SnakeOnline.Screens.Score extends Engine.Screen
  constructor: (game, assets, @snakes) ->
    super game, assets
    @scoreSprites = []
    @scores = []

  draw: (context) ->
    @scoreSprites.forEach (scoreSprite) ->
      scoreSprite.draw context

  update: (span) ->
    @snakes.forEach (snake, i) =>
      return if @scores[i] is snake.score
      @scoreSprites[i] = @createScoreSprite snake, i
      @scores[i] = snake.score

  createScoreSprite: (snake, i) ->
    minecraftiaFont = @assets.minecraftiaFont
    minecraftiaFont.color = snake.color

    sprite = new Engine.Sprite minecraftiaFont.createTexture "#{snake.score}",
      noOffsets: true
      noSpaces: true

    sprite.setPercentage "width", @width, 4, "height"

    switch i
      when 0
        sprite.align = "top-left"
      when 1
        sprite.align = "top-right"
        sprite.x = @width

    delete minecraftiaFont.color
    sprite