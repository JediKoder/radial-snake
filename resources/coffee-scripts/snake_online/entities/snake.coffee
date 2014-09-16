class SnakeOnline.Entities.Snake
  ###
  x (px number) - Initial x
  y (px number) - Initial y
  r (px number) - Radius of steering circle
  rad (radians number) - Initial moving angle
  speed (px/s number) - Moving speed 
  color (color string) - Color
  ###
  constructor: (@x, @y, @r, @rad, @speed, @color) ->
    @shapes = []
    @currShape = new Engine.Geometry.Line {x, y}, {x, y}
    @shapes.push @currShape

  draw: (context) ->
    @shapes.forEach (shape) =>
      context.save()
      context.strokeStyle = @color
      context.beginPath()

      switch shape.constructor.name
        when "Circle"
          context.arc shape.x, shape.y, shape.r, shape.rads[0], shape.rads[1]
        when "Line"
          context.moveTo shape.x1, shape.y1
          context.lineTo shape.x2, shape.y2

      context.stroke()
      context.restore()

  update: (span, direction) ->
    step = @speed * span / 1000

    unless direction is @direction
      @direction = direction

      switch direction
        when "left"
          angle = @rad - 0.5 * Math.PI
          rad = @rad + 0.5 * Math.PI
          x = @x + @r * Math.cos(angle)
          y = @y + @r * Math.sin(angle)
          @currShape = new Engine.Geometry.Circle x, y, @r, [rad, rad]
        when "right"
          angle = @rad + 0.5 * Math.PI
          rad = @rad - 0.5 * Math.PI
          x = @x + @r * Math.cos(angle)
          y = @y + @r * Math.sin(angle)
          @currShape = new Engine.Geometry.Circle x, y, @r, [rad, rad]
        else
          @currShape = new Engine.Geometry.Line {@x, @y}, {@x, @y}

      @shapes.push @currShape

    switch direction
      when "left"
        @currShape.rads[1] -= step / @r
      when "right"
        @currShape.rads[1] += step / @r
      else
        # TODO: Figure the correct ratio
        @currShape.x2 += step * Math.cos(@rad)
        @currShape.y2 += step * Math.sin(@rad)