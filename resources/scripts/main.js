document.addEventListener("DOMContentLoaded", function(event) {
  // Start game on splash screen
  let game = new Engine.Game(document.getElementById("gameCanvas"), false);
  game.changeScreen(Game.Screens.Splash);
  game.play();
});