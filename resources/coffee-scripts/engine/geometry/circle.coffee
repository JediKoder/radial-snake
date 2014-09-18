class Engine.Geometry.Circle
  constructor: (@x, @y, @r, @rad1, @rad2) ->

  getX: (rad) ->
    return unless rad.isBetween @rad1, @rad2, yes
    @r * Math.cos(rad) + @x

  getY: (rad) ->
    return unless rad.isBetween @rad1, @rad2, yes
    @r * Math.sin(rad) + @y

  getPoint: (rad) ->
    return unless rad.isBetween @rad1, @rad2, yes
    x: @getX rad
    y: @getY rad

  getRad: (x, y) ->
    rad = [
      r = Math.acos (x - @x) / @r
      2 * Math.PI + r
      2 * Math.PI - r
      r = Math.asin (y - @y) / @r
      2 * Math.PI + r
      Math.PI - r
    ]

    .common (a, b) ->
      a.compare b

    .filter (r) ->
      r >= 0 and r <= 2 * Math.PI

    rad = rad[0]

    return unless rad?

    rad += 2 * Math.PI * parseInt(@rad1 / (2 * Math.PI))
    rad if rad.isBetween @rad1, @rad2, yes

  hasPoint: (x, y) ->
    @getRad(x, y)?

  getCircleIntersection: (c) ->
    dx = c.x - @x
    dy = c.y - @y
    d = Math.sqrt Math.pow(dx, 2) + Math.pow(dy, 2)

    if d > @r + c.r or
       d < Math.abs(@r - c.r)
      return

    a = (Math.pow(@r, 2) - Math.pow(c.r, 2) + Math.pow(d, 2)) / (2 * d)
    x = @x + dx * a / d
    y = @y + dy * a / d
    h = Math.sqrt Math.pow(@r, 2) - Math.pow(a, 2)
    rx = - dy * h / d
    ry = dx * h / d

    interPoints = [
      x: x + rx
      y: y + ry
    ,
      x: x - rx
      y: y - ry
    ]

    interPoints = _.uniq interPoints, (p) ->
      "(#{p.x}, #{p.y})"

    [this, c].forEach (c) ->
      interPoints = interPoints.filter (p) ->
        c.hasPoint p.x, p.y

    interPoints if interPoints.length > 0

  getLineIntersection: (l) ->
    x1 = l.x1 - @x
    x2 = l.x2 - @x
    y1 = l.y1 - @y
    y2 = l.y2 - @y
    dx = x2 - x1
    dy = y2 - y1
    d = Math.sqrt Math.pow(dx, 2) + Math.pow(dy, 2)
    h = x1 * y2 - x2 * y1
    delta = Math.pow(@r, 2) * Math.pow(d, 2) - Math.pow(h, 2)

    return if delta < 0

    interPoints = [
      x: (h * dy + ((dy / Math.abs(dy)) || 1) * dx * Math.sqrt(delta)) / Math.pow(d, 2) + @x
      y: (-h * dx + Math.abs(dy) * Math.sqrt(delta)) / Math.pow(d, 2) + @y
    ,
      x: (h * dy - ((dy / Math.abs(dy)) || 1) * dx * Math.sqrt(delta)) / Math.pow(d, 2) + @x
      y: (-h * dx - Math.abs(dy) * Math.sqrt(delta)) / Math.pow(d, 2) + @y
    ]

    .filter (p) => 
      @hasPoint(p.x, p.y) and
      l.hasPoint(p.x, p.y)

    interPoints = _.uniq interPoints, (p) ->
      "(#{p.x}, #{p.y})"

    interPoints if interPoints.length > 0