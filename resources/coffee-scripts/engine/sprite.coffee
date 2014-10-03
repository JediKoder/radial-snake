class Engine.Sprite
  constructor: (@texture) ->
    @x = 0
    @y = 0
    @width = texture.width
    @height = texture.height
    @pivot = x: 0, y: 0
    @opacity = 1

  draw: (context, offsetX = 0, offsetY = 0) ->
    context.save()
    context.globalAlpha = @opacity

    switch @align
      when "top-left", "left-top" then @pivot = x: 0, y: 0
      when "top-right", "right-top" then @pivot = x: @width, y: 0
      when "bottom-left", "left-bottom" then @pivot = x: 0, y: @height
      when "bottom-right", "right-bottom" then @pivot = x: @width, y: @height
      when "middle", "center" then @pivot = x: @width / 2, y: @height / 2
      when "left" then @pivot = x: 0, y: @height / 2
      when "top" then @pivot = x: @width / 2, y: 0
      when "right" then @pivot = x: @width, y: @height / 2
      when "bottom" then @pivot = x: @width / 2, y: @height

    context.drawImage @texture,
      @x - @pivot.x + offsetX
      @y - @pivot.y + offsetY
      @width
      @height

    context.restore()

  setPercentage: (key, relative, percents, adapters...) ->
    oldVal = @[key]
    newVal = @[key] = percents * relative / 100
    ratio = newVal / oldVal

    adapters.forEach (adapter) =>
      @[adapter] *= ratio