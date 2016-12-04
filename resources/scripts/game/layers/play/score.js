Game.Layers.Play.Score = class Score extends Engine.Layer {
  constructor(game, snakes) {
    super(game);
    this.snakes = snakes;
    this.scoreSprites = [];
    this.scores = [];

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
      if (this.scores[i] === snake.score) return;
      this.scoreSprites[i] = this.createScoreSprite(snake, i);
      this.scores[i] = snake.score;
    });
  }

  createScoreSprite(snake, i) {
    let { minecraftiaFont } = this.assets;
    minecraftiaFont.save();
    minecraftiaFont.color = snake.color;

    let sprite = new Engine.Sprite(minecraftiaFont.createTexture(`${snake.score}`, {
      noOffsets: true,
      noSpaces: true
    }));

    sprite.setPercentage("width", this.width, 4, "height");

    switch (snake.index) {
      case 0:
        sprite.align = "top-left";
        break;
      case 1:
        sprite.align = "top-right";
        sprite.x = this.width;
        break;
    }

    minecraftiaFont.restore();
    return sprite;
  }
};