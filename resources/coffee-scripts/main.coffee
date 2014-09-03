window.onload = ->
  new SnakeOnline.Game(document.getElementById("gameCanvas"), SnakeOnline.Screens.SplashLoading, no).play()