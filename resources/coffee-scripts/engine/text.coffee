class Engine.Text
  constructor: (@text, @font) ->
    @location = x: 0, y: 0
    @opacity = 1
    @color = "white"

  draw: (context, offsetX = 0, offsetY = 0) ->
    context.save()
    context.globalAlpha = @opacity
    context.fillStyle = @color
    context.font = @font
    context.textAlign = @align

    context.fillText @text,
      @location.x + offsetX
      @location.y + offsetY

    context.restore()

  getMetrics: (context) ->
    context.save()
    context.font = @font
    metrics = context.measureText @text
    context.restore()
    metrics