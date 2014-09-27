window.onload = ->
  new SnakeOnline.Game(doc.getElementById("gameCanvas"), SnakeOnline.Screens.SplashLoading, yes).play()