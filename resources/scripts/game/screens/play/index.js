Game.Screens.Play = class Play extends Engine.Screen {
  get events() {
    return {
      "keydown": "onKeyDown"
    }
  }

  initialize() {
    this.appendLayer(Game.Screens.Play.Ready);
  }

  onKeyDown() {
    // esc
    if (this.keyStates.get(27)) {
      this.game.changeScreen(Game.Screens.Menu);
    }
  }
};