class Engine.Geometry.Circle
  constructor: (@x = 0, @y = 0, @r, @rads = rads = []) ->
    unless r?
      throw new Error "r must be defined for Circle"

    rads.push 0 * Math.PI unless rads[0]?
    rads.push 2 * Math.PI unless rads[1]?

  getX: (rad) ->
    return unless rad.isInRange @rads, yes
    @r * Math.cos(rad) + @x

  getY: (rad) ->
    return unless rad.isInRange @rads, yes
    @r * Math.sin(rad) + @y

  getPoint: (rad) ->
    return unless rad.isInRange @rads, yes
    x: @getX rad
    y: @getY rad

  getRad: (p) ->
    rad = [
      r = Math.acos (p.x - @x) / @r
      2 * Math.PI + r
      2 * Math.PI - r
      r = Math.asin (p.y - @y) / @r
      2 * Math.PI + r
      Math.PI - r
    ].common()[0]

    rad if rad.isInRange @rads, yes

  hasPoint: (p) ->
    @getRad(p)? and
    Math.pow(@r, 2) is Math.pow(p.x - @x, 2) + Math.pow(p.y - @y, 2)

  getCircleIntersect: (c) ->
    if @x is c.x and @y is c.y and @r is c.r
      return @getPartial c.rads

    dx = c.x - @x
    dy = c.y - @y
    d = Math.sqrt Math.pow(dx, 2) + Math.pow(dy, 2)

    if d > @r + c.r or
       d < Math.abs(@r - c.r)
      return

    ###
    Point2 is where the line through the circle intersection points 
    crosses the line between circle centers
    ###

    # Distance between point 0 and point 2
    a = (Math.pow(@r, 2) - Math.pow(c.r, 2) + Math.pow(d, 2)) / (2 * d)

    # Coordinates of point 2
    x = @x + dx * a / d
    y = @y + dy * a / d
    # Distance from point 2 to one of the intersection points
    h = Math.sqrt Math.pow(@r, 2) - Math.pow(a, 2)
    # The offset of the intersection points
    rx = - dy * h / d
    ry = dx * h / d

    # Absolute intersection points
    interPoints = _.uniq [
      x: x + rx
      y: y + ry
    ,
      x: x - rx
      y: y - ry
    ]

    if _.isEqual interPoints[0], interPoints[1]
      interPoints.pop()

    [this, c].forEach (c) ->
      return unless c.rads?
      interPoints = interPoints.filter (p) =>
        c.getRad(p)?

    interPoints

  getPartial: (rads) ->
    commonRads = []

    [0..1].forEach =>
      rads.forEach (r) =>
        if (p = @getPoint(r))? and @getRad(p)?
          commonRads.push r

      radsBack = @rads
      @rads = rads
      rads = radsBack

    if commonRads.length > 0
      new @constructor @x, @y, @r, commonRads