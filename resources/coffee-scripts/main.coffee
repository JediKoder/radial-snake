$(doc).ready ->
  new SnakeOnline.Game(doc.getElementById("gameCanvas"), SnakeOnline.Screens.Init, no).play()