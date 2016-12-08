Game.Screens.Play.Score = class Score extends Engine.Layer {
  constructor(screen, snakes) {
    super(screen);
    this.snakes = snakes;
    this.scoreSprites = [];
    this.scores = [];

    // It's important to match indexes to each snake since the number of snakes
    // can be reduced along the way as we play
    snakes.forEach(function(snake, i) {
      snake.index = i;
    });
  }

  draw(context) {
    this.scoreSprites.forEach(function(scoreSprite) {
      scoreSprite.draw(context);
    });
  }

  update(span) {
    this.snakes.forEach(snake => {
      let i = snake.index;
      if (this.scores[i] == snake.score) return;
      // The sprite might be changed along the way so it's important to recreate it
      // over and over again. If no change was made the cache will be used by the engine
      this.scoreSprites[i] = this.createScoreSprite(snake);
      this.scores[i] = snake.score;
    });
  }

  createScoreSprite(snake) {
    let { minecraftiaFont } = this.assets;
    minecraftiaFont.save();
    minecraftiaFont.color = snake.color;

    // Create a score sprite for the snake
    let sprite = new Engine.Sprite(minecraftiaFont.createTexture(`${snake.score}`, {
      noOffsets: true,
      noSpaces: true
    }));

    // Size of score board is dynamic to screen size
    sprite.setPercentage("width", this.width, 4, "height");

    // Set alignment modes.
    // Once we add more snakes we should add more cases here
    switch (snake.index) {
      case 0:
        sprite.align = "top-left";
        break;
      case 1:
        sprite.align = "top-right";
        sprite.x = this.width;
        break;
    }

    // Restore the font to its original color
    minecraftiaFont.restore();
    return sprite;
  }
};