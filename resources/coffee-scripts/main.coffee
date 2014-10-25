$(doc).ready ->
  game = new SnakeOnline.Game $("#gameCanvas")[0], no
  game.changeScreen SnakeOnline.Screens.Splash
  game.play()