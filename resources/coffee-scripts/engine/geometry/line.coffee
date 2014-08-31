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
    x if isNaN(x) or x.isBetween(@x1, @x2, yes)

  getY: (x) ->
    y = (x - @x1) * (@y2 - @y1) / (@x2 - @x1) + @y1
    y if isNaN(y) or y.isBetween(@y1, @y2, yes)

  hasPoint: (p) ->
    x = @getX p.y
    y = @getY p.x
    ((isNaN(x) and p.x.isBetween @x1, @x2, yes) or x?.compare(p.x)) and
    ((isNaN(y) and p.y.isBetween @y1, @y2, yes) or y?.compare(p.y))

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