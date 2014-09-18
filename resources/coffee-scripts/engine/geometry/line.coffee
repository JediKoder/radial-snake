class Engine.Geometry.Line
  constructor: (@x1, @y1, @x2, @y2) ->

  getX: (y) ->
    x = (y - @y1) * (@x2 - @x1) / (@y2 - @y1) + @x1
    x if isNaN(x) or x.isBetween(@x1, @x2, yes)

  getY: (x) ->
    y = (x - @x1) * (@y2 - @y1) / (@x2 - @x1) + @y1
    y if isNaN(y) or y.isBetween(@y1, @y2, yes)

  hasPoint: (x, y) ->
    lx = @getX y
    ly = @getY x
    ((isNaN(lx) and x.isBetween @x1, @x2, yes) or lx?.compare(x)) and
    ((isNaN(ly) and y.isBetween @y1, @y2, yes) or ly?.compare(y))

  getLineIntersection: (l) ->
    return unless (@x1 - @x2) * (l.y1 - l.y2) - (@y1 - @y2) * (l.x1 - l.x2)

    x = ((@x1 * @y2 - @y1 * @x2) * (l.x1 - l.x2) - (@x1 - @x2) * (l.x1 * l.y2 - l.y1 * l.x2)) / 
        ((@x1 - @x2) * (l.y1 - l.y2) - (@y1 - @y2) * (l.x1 - l.x2))
    y = ((@x1 * @y2 - @y1 * @x2) * (l.y1 - l.y2) - (l.y1 - l.y2) * (l.x1 * l.y2 - l.y1 * l.x2)) /
        ((@x1 - @x2) * (l.y1 - l.y2) - (@y1 - @y2) * (l.x1 - l.x2))

    if x.isBetween(@x1, @x2, yes) and x.isBetween(l.x1, l.x2, yes) and
       y.isBetween(@y1, @y2, yes) and y.isBetween(l.y1, l.y2, yes)
      x: x, y: y

  getCircleIntersection: (c) ->
    Engine.Geometry.Circle::getLineIntersection.call c, this