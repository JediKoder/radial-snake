class Engine.Geometry.Line
  constructor: (x1, y1, x2, y2) ->
    @x1 = x1.trim 9
    @y1 = y1.trim 9
    @x2 = x2.trim 9
    @y2 = y2.trim 9

  getX: (y) ->
    x = ((y - @y1) * (@x2 - @x1) / (@y2 - @y1) + @x1).trim 9
    x if isNaN(x) or x.isBetween(@x1, @x2)

  getY: (x) ->
    y = ((x - @x1) * (@y2 - @y1) / (@x2 - @x1) + @y1).trim 9
    y if isNaN(y) or y.isBetween(@y1, @y2)

  hasPoint: (x, y) ->
    return false unless @boundsHasPoint x, y
    m = ((@y2 - @y1) / (@x2 - @x1)).trim 9
    y - @y1 is m * (x - @x1)

  boundsHasPoint: (x, y) ->
    x.isBetween(@x1, @x2) and
    y.isBetween(@y1, @y2)

  getLineIntersection: (l) ->
    return unless (@x1 - @x2) * (l.y1 - l.y2) - (@y1 - @y2) * (l.x1 - l.x2)

    x = (((@x1 * @y2 - @y1 * @x2) * (l.x1 - l.x2) - (@x1 - @x2) * (l.x1 * l.y2 - l.y1 * l.x2)) / 
        ((@x1 - @x2) * (l.y1 - l.y2) - (@y1 - @y2) * (l.x1 - l.x2))).trim 9
    y = (((@x1 * @y2 - @y1 * @x2) * (l.y1 - l.y2) - (@y1 - @y2) * (l.x1 * l.y2 - l.y1 * l.x2)) /
        ((@x1 - @x2) * (l.y1 - l.y2) - (@y1 - @y2) * (l.x1 - l.x2))).trim 9

    if x.isBetween(@x1, @x2) and x.isBetween(l.x1, l.x2) and
       y.isBetween(@y1, @y2) and y.isBetween(l.y1, l.y2)
      x: x, y: y

  getCircleIntersection: (c) ->
    Engine.Geometry.Circle::getLineIntersection.call c, this