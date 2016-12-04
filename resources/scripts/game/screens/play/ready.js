Game.Screens.Play.Ready = class Ready extends Engine.Layer {
  get events() {
    return {
      "keydown": "onKeyDown"
    };
  }

  constructor(screen, snakes) {
    super(screen);
    this.snakes = snakes;

    let readySprite = new Engine.Sprite(this.assets.minecraftiaFont.createTexture("Ready"));
    readySprite.align = "center";
    readySprite.setPercentage("width", this.width, 15, "height");

    this.readyAnim = new Engine.Animations.Keyframe(readySprite, [
      {
        x: this.width / 2,
        y: this.height / 2,
        opacity: 1,
        frame: 0
      },
      {
        y: this.height / 3,
        opacity: 0,
        frame: 700
      }
    ]);
  }

  draw(context) {
    this.readyAnim.draw(context);
  }

  update(span) {
    if (!this.ready) return;

    if (this.readyAnim.playing) {
      this.readyAnim.update(span);
    }
    else {
      this.screen.removeLayer(this);
    }
  }

  onKeyDown() {
    this.disposeEventListeners()

    this.ready = true;
    this.readyAnim.play();
    this.screen.prependLayer(Game.Screens.Play.Snake, this.snakes);
  }
};