class Engine.Geometry.Line
  constructor: ->
    if args.length is 1 or 
       args[1] instanceof Array
      [x, limits] = args
      @x = x || 0
    else
      [m, n, limits] = args
      @m = m || 0
      @n = n || 0
        
    @limits = limits || []
    [@xLimits = _.pluck limits, "x"
     @yLimits = _.pluck limits, "y"]
    
    .forEach (limits) ->
      limits.push -Infinity unless limits[0]?
      limits.push Infinity unless limits[1]?

  getX: (y) ->
    x =
      if @x?
        @x
      else if @m is 0
        NaN
      else
        (y - @n) / @m

    x if x.isInRange @xLimits

  getY: (x) ->
    y =
      if @x?
        NaN
      else
        @m * x + @n

    y if y.isInRange @yLimits

  hasPoint: (p) ->
    @isPointInLimits(p) and
    (@x is p.x or @m * p.x + @n is p.y)

  isPointInLimits: (p) ->
    p.x? and p.y? and
    p.x.isInRange(@xLimits) and
    p.y.isInRange(@yLimits)

  getLineIntersect: (l) ->
    if @x?
      if l.x?
        if @x is l.x
          return @getPartial l.limits
      else
        interPoint =
          x: @x
          y: l.getY @x
    else if l.x?
      interPoint =
        x: l.x
        y: @getY l.x
    else if @m is l.m
      if @n is l.n
        return @getPartial l.limits
    else
      interPoint =
        x: x = (l.n - @n) / (@m - l.m)
        y: y = @getY x

    [this, l].forEach (l) ->
      return unless interPoint?
      interPoint = undefined unless l.isPointInLimits interPoint

    interPoint

  getPartial: (limits) ->
    commonLimits = []

    [0..1].forEach =>
      limits.forEach (l) =>
        commonLimits.push l if @isPointInLimits l

      limitsBackup = @limits
      @limits = limits
      @xLimits = _.pluck limits, "x"
      @yLimits = _.pluck limits, "y"
      limits = limitsBackup

    if commonLimits.length > 0
      if @x?
        new @constructor @x, commonLimits
      else
        new @constructor @m, @n, commonLimits

  @getLine: (p0, p1) ->
    m = (p0.y - p1.y) / (p0.x - p1.x)
    n = p0.y - m * p0.x

    if isFinite m
      new this m, n
    else
      new this p0.x