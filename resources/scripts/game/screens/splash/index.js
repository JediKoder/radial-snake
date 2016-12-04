Game.Screens.Splash = class Splash extends Engine.Screen {
  initialize() {
    let splashSprite = new Engine.Sprite(this.assets.splashTexture);
    splashSprite.align = "center";
    splashSprite.x = this.width / 2;

    this.splashAnim = new Engine.Animations.Keyframe(splashSprite, [{
        y: (this.height / 2) - 30,
        width: splashSprite.width / 4,
        height: splashSprite.height / 4,
        opacity: 0,
        easing: "in",
        frame: 0
      },
      {
        y: this.height / 2,
        width: (splashSprite.width / 3) + (splashSprite.width * 0.05),
        height: (splashSprite.height / 3) + (splashSprite.height * 0.05),
        opacity: 1,
        frame: 3000
      },
      {
        frame: 3500
      }
    ]);

    this.splashAnim.play();
  }

  load(assetsLoader) {
    let minecraftiaFont = assetsLoader.font("/fonts/minecraftia");
    let splashTexture = assetsLoader.texture("/textures/splash");
    let logoTexture = assetsLoader.texture("/textures/logo");

    this.game.extendAssets({
      minecraftiaFont,
      logoTexture
    });

    return { splashTexture };
  }

  draw(context) {
    this.splashAnim.draw(context);
  }

  update(span) {
    if (this.splashAnim.playing) {
      this.splashAnim.update(span);
    }
    else {
      this.game.changeScreen(Game.Screens.Menu);
    }
  }
};