Game.Screens.Play.Win = class Win extends Engine.Layer {
  constructor(screen, snakes, winner) {
    super(screen);
    this.snakes = snakes;
    this.winner = winner;
    this.ttl = 3000;

    if (this.winner) {
      var text = `${this.winner.color.toUpperCase()} SNAKE WINS`;
      var percent = 40;
    }
    else {
      var text = 'TIE';
      var percent = 15;
    }

    this.winnerSprite = new Engine.Sprite(this.assets.minecraftiaFont.createTexture(text));
    this.winnerSprite.align = "center";
    this.winnerSprite.setPercentage("width", this.width, percent, "height");
    this.winnerSprite.x = this.width / 2;
    this.winnerSprite.y = this.height / 2;
  }

  draw(context) {
    this.winnerSprite.draw(context);
  }

  update(span) {
    if (this.age >= this.ttl) {
      this.screen.layers.splice(this);
      this.screen.appendLayer(Game.Screens.Play.Ready, this.snakes);
    }
  }
};