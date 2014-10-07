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
      motion = getKeyframesMo.call this, k
      return unless motion?
      @sprite[k] = calcRelativeVal.call this, motion, k

  getKeyframesMo = (k) ->
    keyframes = @trimmedKeyframesMap[k]

    if not keyframes? or
       keyframes.length < 2 or
       @frame > _(keyframes).last().frame
      return

    start = findStartKeyframe.call this, keyframes
    end = findEndKeyframe.call this, keyframes
    ratio = getKeyframesRatio.call this, start, end

    start: start
    end: end
    ratio: ratio

  getKeyframesRatio = (start, end) ->
    (@frame - start.frame) / (end.frame - start.frame)

  findEndKeyframe = (keyframes) ->
    _(keyframes).find (k) =>
      k.frame >= (@frame || 1)

  findStartKeyframe = (keyframes) ->
    index = undefined

    keyframes.some (k, i) =>
      if k.frame >= (@frame || 1)
        index = i
        yes

    keyframes[index - 1]

  calcRelativeVal = (motion, k) ->
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