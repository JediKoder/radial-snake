class Engine.Geometry.Circle
  constructor: (x, y, r, rad1, rad2) ->
    @x = x.trim 9
    @y = y.trim 9
    @r = r.trim 9

    if rad1 > rad2
      @rad1 = rad1.trim 9, "floor"
      @rad2 = rad2.trim 9, "ceil"
    else
      @rad1 = rad1.trim 9, "ceil"
      @rad2 = rad2.trim 9, "floor"

  getX: (rad) ->
    return unless rad.isBetween @rad1, @rad2
    (@r * Math.cos(rad) + @x).trim 9

  getY: (rad) ->
    return unless rad.isBetween @rad1, @rad2
    (@r * Math.sin(rad) + @y).trim 9

  getPoint: (rad) ->
    return unless rad.isBetween @rad1, @rad2
    x: (@r * Math.cos(rad) + @x).trim 9
    y: (@r * Math.sin(rad) + @y).trim 9

  getRad: (x, y) ->
    rad = Math.atan2 y - @y, x - @x

    if rad?.isBetween @rad1, @rad2
      return rad

    cycRad = if Math.abs(@rad1) > Math.abs(@rad2)
      @rad1
    else
      @rad2

    if (rad + 2 * Math.PI * Math.floor(cycRad / (2 * Math.PI))).trim(9).isBetween(@rad1, @rad2) or
       (rad + 2 * Math.PI * Math.ceil(cycRad / (2 * Math.PI))).trim(9).isBetween(@rad1, @rad2)
      rad

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

    .map (p) ->
      x: p.x.trim 9
      y: p.y.trim 9

    interPoints = _(interPoints).uniq (p) ->
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

    .map (p) ->
      x: p.x.trim 9
      y: p.y.trim 9

    .filter (p) => 
      @hasPoint(p.x, p.y) and
      l.boundsHasPoint(p.x, p.y)

    interPoints = _(interPoints).uniq (p) ->
      "(#{p.x}, #{p.y})"

    interPoints if interPoints.length > 0