$(doc).ready ->
  new SnakeOnline.Game(doc.getElementById("gameCanvas"), SnakeOnline.Screens.SplashLoading, no).play()