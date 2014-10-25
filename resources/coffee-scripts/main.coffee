$(doc).ready ->
  game = new Engine.Game $("#gameCanvas")[0], no
  game.changeScreen Game.Screens.Splash
  game.play()