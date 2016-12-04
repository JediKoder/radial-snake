Game.Screens.Play = class Play extends Engine.Screen {
  initialize() {
    this.appendLayer(Game.Screens.Play.Ready);
  }
};