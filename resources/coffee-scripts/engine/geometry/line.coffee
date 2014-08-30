class Engine.Geometry.Line
  constructor: (@p1, @p2) ->
    Object.defineProperties this,
      x1: 
        get: -> 
          @p1.x
        set: (v) -> 
          @p1.x = v
      ,
      x2: 
        get: -> 
          @p2.x
        set: (v) -> 
          @p2.x = v
      ,
      y1: 
        get: -> 
          @p1.y
        set: (v) -> 
          @p1.y = v
      ,
      y2: 
        get: ->
          @p2.y
        set: (v) -> 
          @p2.y = v

  getX: (y) ->
    x = (y - @y1) * (@x2 - @x1) / (@y2 - @y1) + @x1
    x if x.isBetween @x1, @x2

  getY: (x) ->
    y = (x - @x1) * (@y2 - @y1) / (@x2 - @x1) + @y1
    y if y.isBetween @y1, @y2

  hasPoint: (p) ->
    p.y is @getY p.x

  getLineIntersection: (l) ->
    return unless (@x1 - @x2) * (l.y1 - l.y2) - (@y1 - @y2) * (l.x1 - l.x2)

    x = ((@x1 * @y2 - @y1 * @x2) * (l.x1 - l.x2) - (@x1 - @x2) * (l.x1 * l.y2 - l.y1 * l.x2)) / 
        ((@x1 - @x2) * (l.y1 - l.y2) - (@y1 - @y2) * (l.x1 - l.x2))
    y = ((@x1 * @y2 - @y1 * @x2) * (l.y1 - l.y2) - (l.y1 - l.y2) * (l.x1 * l.y2 - l.y1 * l.x2)) /
        ((@x1 - @x2) * (l.y1 - l.y2) - (@y1 - @y2) * (l.x1 - l.x2))

    x: x, y: y if x.isBetween(@x1, @x2) and x.isBetween(l.x1, l.x2)

  getCircleIntersection: (c) ->
    dx = @x2 - @x1
    dy = @y2 - @y1
    d = Math.sqrt Math.pow(dx, 2) + Math.pow(dy, 2)
    h = @x1 * @y2 - @x2 * @y1
    delta = Math.pow(c.r, 2) * Math.pow(d, 2) - Math.pow(h, 2)

    return if delta < 0

    interPoints = [
      x: (h * dy + (dy / Math.abs(dy)) * dx * Math.sqrt(delta)) / Math.pow(d, 2)
      y: (-h * dx + Math.abs(dy) * Math.sqrt(delta)) / Math.pow(d, 2)
    ,
      x: (h * dy - (dy / Math.abs(dy)) * dx * Math.sqrt(delta)) / Math.pow(d, 2)
      y: (-h * dx - Math.abs(dy) * Math.sqrt(delta)) / Math.pow(d, 2)
    ].filter (p) => @hasPoint p

    interPoints if interPoints.length > 0