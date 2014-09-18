class SnakeOnline.Entities.Snake
  ###
  x (px number) - Initial x
  y (px number) - Initial y
  r (px number) - Radius of steering circle
  rad (radians number) - Initial moving angle
  v (px/s number) - Moving speed 
  color (color string) - Color
  ###
  constructor: (@x, @y, @r, @rad, @v, @color, @keyStates, options) ->
    @shapes = []
    @currShape = new Engine.Geometry.Line x, y, x, y
    @shapes.push @currShape
    
    if options?.keys?
      @left = options.keys.leftKey
      @right = options.keys.rightKey
    else
      @leftKey = 37 # Left arrow
      @rightKey = 39 # Right arrow

  draw: (context) ->
    @shapes.forEach (shape) =>
      context.save()
      context.strokeStyle = @color
      context.beginPath()

      if shape.constructor.name is "Line"
        context.moveTo shape.x1, shape.y1
        context.lineTo shape.x2, shape.y2
      else
        context.arc shape.x, shape.y, shape.r, shape.rad1, shape.rad2

      context.stroke()
      context.restore()

  update: (span) ->
    step = @v * span / 1000

    if @currShape.constructor.name is "Line"
      @x = @currShape.x2
      @y = @currShape.y2

    else
      if @direction is "left"
        @rad = @currShape.rad1
        {@x, @y} = @currShape.getPoint @rad
        @rad -= 0.5 * Math.PI
      else
        @rad = @currShape.rad2
        {@x, @y} = @currShape.getPoint @rad
        @rad += 0.5 * Math.PI

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