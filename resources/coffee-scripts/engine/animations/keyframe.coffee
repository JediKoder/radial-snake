class Engine.Animations.Keyframe
  constructor: (@sprite, @keyframes) ->
    @age = 0
    @frame = 0
    @repMode = "none"
    @lastKeyframe = _.last keyframes
    @lastFrame = @lastKeyframe.frame

    @animables = [
      "x"
      "y"
      "width"
      "height"
      "opacity"
    ]

    @trimmedKeyframesMap = @animables.reduce (trimmedKeyframesMap, k) ->
      trimmedKeyframesMap[k] = keyframes.filter (keyframe) -> keyframe[k]?
      trimmedKeyframesMap
    , {}

    keyframes[0].forEach (k, v) =>
      sprite[k] = v if k in @animables

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

    @animables.forEach (k) =>
      motion = @_getKeyframesMo k
      return unless motion?
      @sprite[k] = @_calcRelativeVal motion, k

  _getKeyframesMo: (k) ->
    keyframes = @trimmedKeyframesMap[k]

    if not keyframes? or
       keyframes.length < 2 or
       @frame > _.last(keyframes).frame
      return

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
      k.frame >= (@frame || 1)

  _findStartKeyframe: (keyframes) ->
    index = undefined

    keyframes.some (k, i) =>
      if k.frame >= (@frame || 1)
        index = i
        yes

    keyframes[index - 1]

  _calcRelativeVal: (motion, k) ->
    a = motion.start[k]
    b = motion.end[k]
    r = motion.ratio

    easing = if r > 0
      motion.start.easing
    else
      motion.end.easing

    r = switch easing
      when "in" then Math.sin r * Math.PI / 2
      when "out" then Math.cos r * Math.PI / 2
      else r

    (b - a) * r + a