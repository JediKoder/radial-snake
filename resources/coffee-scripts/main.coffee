$(doc).ready ->
  game = new SnakeOnline.Game $("#gameCanvas")[0], no
  game.changeScreen new SnakeOnline.Screens.Splash game
  game.play()