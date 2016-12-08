Game.Screens.Splash = class Splash extends Engine.Screen {
  initialize() {
    // Create splash sprite and set its properties
    let splashSprite = new Engine.Sprite(this.assets.splashTexture);
    splashSprite.align = "center";
    splashSprite.x = this.width / 2;

    // Create splash sprite animation
    this.splashAnim = new Engine.Animations.Keyframe(splashSprite, [
      {
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

    // Start playing animation
    this.splashAnim.play();
  }

  load(assetsLoader) {
    // Load assets
    let minecraftiaFont = assetsLoader.font("/fonts/minecraftia");
    let splashTexture = assetsLoader.texture("/textures/splash");
    let logoTexture = assetsLoader.texture("/textures/logo");

    // These are global assets
    // Note that we load the logo texture now to prevent loading time in the next screen
    this.game.extendAssets({
      minecraftiaFont,
      logoTexture
    });

    // These are local assets which will be disposed along with the screen
    return { splashTexture };
  }

  draw(context) {
    this.splashAnim.draw(context);
  }

  update(span) {
    if (this.splashAnim.playing) {
      this.splashAnim.update(span);
    }
    // If animation is not playing anymore, move on to the next screen
    // which is the main menu screen
    else {
      this.game.changeScreen(Game.Screens.Menu);
    }
  }
};