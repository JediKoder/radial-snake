class Engine.Animations.Keyframe
  constructor: (texture, @keyframes, options) ->
    @age = 0
    @frame = 0
    @repMode = "none"
    @lastKeyframe = _.last keyframes
    @lastFrame = @lastKeyframe.frame
    @sprite = new Engine.Sprite texture

    options.forEach (k, option) =>
      property = @sprite[k]

      if typeof property is "function"
        if option instanceof Array
          property.apply @sprite, option
        else
          property.call @sprite, option
      else
        @sprite[k] = option

    keyframes[0].forEach (k, option) =>
      property = @sprite[k]

      if typeof property is "object"
        _.extend property, option
      else
        @sprite[k] = option

    @widths = keyframes.filter (k) -> k.width?
    @heights = keyframes.filter (k) -> k.height? 
    @opacities = keyframes.filter (k) -> k.opacity? 
    @locations = keyframes.filter (k) -> k.location?
    @locations.xs = @locations.filter (k) -> k.location.x?
    @locations.ys = @locations.filter (k) -> k.location.y?

  draw: (context, offsetX, offsetY) ->
    @sprite.draw context, offsetX, offsetY

  update: (span) ->
    return unless @playing
    @age += span

    switch @repMode
      when "none"
        if (@frame += span) > @lastFrame
          @frame = @lastFrame
          @playing = no

      when "cyclic"
        @frame = @age % @lastFrame

      when "full"
        @frame = @age % @lastFrame
        @frame = @lastFrame - @frame if @age / @lastFrame % 2 >= 1

    widthMo = @_getKeyframesMo @widths
    heightMo = @_getKeyframesMo @heights
    opacityMo = @_getKeyframesMo @opacities
    xMo = @_getKeyframesMo @locations.xs
    yMo = @_getKeyframesMo @locations.ys

    @sprite.width = @_calcRelativeVal widthMo.start.width, widthMo.end.width, widthMo.ratio if widthMo?
    @sprite.height = @_calcRelativeVal heightMo.start.height, heightMo.end.height, heightMo.ratio if heightMo?
    @sprite.opacity = @_calcRelativeVal opacityMo.start.opacity, opacityMo.end.opacity, opacityMo.ratio if opacityMo?
    @sprite.location.x = @_calcRelativeVal xMo.start.location.x, xMo.end.location.x, xMo.ratio if xMo?
    @sprite.location.y = @_calcRelativeVal yMo.start.location.y, yMo.end.location.y, yMo.ratio if yMo?

  _getKeyframesMo: (keyframes) ->
    return if keyframes.length < 2 or @frame > _.last(keyframes).frame
    start = @_findStartKeyframe keyframes
    end = @_findEndKeyframe keyframes
    ratio = @_getKeyframesRatio start, end

    start: start
    end: end
    ratio: ratio

  _getKeyframesRatio: (start, end) ->
    (@frame - start.frame) / (end.frame - start.frame)

  _findEndKeyframe: (keyframes) ->
    _.find keyframes, (k) =>
      k.frame >= @frame

  _findStartKeyframe: (keyframes) ->
    keyframes[keyframes.indexOf(_.find keyframes, (k) =>
      k.frame >= @frame
    ) - 1]

  _calcRelativeVal: (a, b, r) ->
    (b - a) * r + a