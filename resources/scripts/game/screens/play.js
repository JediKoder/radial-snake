Game.Screens.Play = class Play extends Engine.Screen {
  initialize() {
    this.appendLayer(Game.Layers.Play.Ready);
  }
};