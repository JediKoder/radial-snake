$(doc).ready ->
  new SnakeOnline.Game($("#gameCanvas")[0], SnakeOnline.Screens.Init, no).play()