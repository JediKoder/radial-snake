$(document).ready(() => {
  let game = new Engine.Game($("#gameCanvas")[0], false);
  game.changeScreen(Game.Screens.Splash);
  game.play();
});