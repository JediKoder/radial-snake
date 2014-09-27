class SnakeOnline.Entities.Snake
  constructor: (@x, @y, @r, @rad, @v, @color, @keyStates, options) ->
    @shapes = []
    @currShape = new Engine.Geometry.Line x, y, x, y
    @shapes.push @currShape
    @score = 0
    
    if options?.keys?
      @leftKey = options.keys.left
      @rightKey = options.keys.right
    else
      @leftKey = 37 # Left arrow
      @rightKey = 39 # Right arrow

  draw: (context) ->
    @shapes.forEach (shape) =>
      context.save()
      context.strokeStyle = @color
      context.beginPath()

      if shape instanceof Engine.Geometry.Line
        context.moveTo shape.x1, shape.y1
        context.lineTo shape.x2, shape.y2
      else
        context.arc shape.x, shape.y, shape.r, shape.rad1, shape.rad2

      context.stroke()
      context.restore()

  update: (span) ->
    step = @v * span / 1000

    if @currShape instanceof Engine.Geometry.Line
      {x: lastX, y: lastY} = this
      @x = @currShape.x2
      @y = @currShape.y2
      @lastBit = new Engine.Geometry.Line lastX, lastY, @x, @y
    else
      {x: lastX, y: lastY, r: lastR} = @currShape

      if @direction is "left"
        lastRad = @rad + 0.5 * Math.PI
        {@x, @y} = @currShape.getPoint @currShape.rad1
        @rad = @currShape.rad1 - 0.5 * Math.PI
        @lastBit = new Engine.Geometry.Circle lastX, lastY, lastR, @currShape.rad1, lastRad
      else
        lastRad = @rad - 0.5 * Math.PI
        {@x, @y} = @currShape.getPoint @currShape.rad2
        @rad = @currShape.rad2 + 0.5 * Math.PI
        @lastBit = new Engine.Geometry.Circle lastX, lastY, lastR, lastRad, @currShape.rad2

    direction = if @keyStates.get @leftKey
      "left"
    else if @keyStates.get @rightKey
      "right"

    unless direction is @direction
      @direction = direction

      switch direction
        when "left"
          angle = @rad - 0.5 * Math.PI
          rad = @rad + 0.5 * Math.PI
          x = @x + @r * Math.cos(angle)
          y = @y + @r * Math.sin(angle)
          @currShape = new Engine.Geometry.Circle x, y, @r, rad, rad
        when "right"
          angle = @rad + 0.5 * Math.PI
          rad = @rad - 0.5 * Math.PI
          x = @x + @r * Math.cos(angle)
          y = @y + @r * Math.sin(angle)
          @currShape = new Engine.Geometry.Circle x, y, @r, rad, rad
        else
          @currShape = new Engine.Geometry.Line @x, @y, @x, @y

      @shapes.push @currShape

    switch direction
      when "left"
        @currShape.rad1 -= step / @r
      when "right"
        @currShape.rad2 += step / @r
      else
        @currShape.x2 += step * Math.cos(@rad)
        @currShape.y2 += step * Math.sin(@rad)

  getSelfIntersection: ->
    if @currShape instanceof Engine.Geometry.Circle and
       Math.abs(@currShape.rad1 - @currShape.rad2) >= 2 * Math.PI
      return @currShape.getPoint if @direction is "left"
        @currShape.rad1
      else
        @currShape.rad2

    result = undefined

    @shapes.slice(0, -2).some (s) =>
      if s instanceof Engine.Geometry.Line
        result = @lastBit.getLineIntersection s
      else
        result = @lastBit.getCircleIntersection s

    result

  getSnakeIntersection: (snake) ->
    result = undefined

    snake.shapes.some (s) =>
      result = if s instanceof Engine.Geometry.Line
        @lastBit.getLineIntersection s
      else
        @lastBit.getCircleIntersection s

    result