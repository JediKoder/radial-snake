class Engine.Font extends Restoreable
  constructor: ->
    super "color"
    @charSpritesMap = {}

  createTexture: (text, options) ->
    {noOffsets, noSpaces} = options if options?
    canvas = doc.newEl "canvas"
    context = canvas.getContext "2d"
    height = canvas.height = @data.height

    width = canvas.width = _.reduce text, (width, c) =>
      width + if noSpaces
        @getCharSprite(c).width
      else
        @data.chars[c].width
    , 0

    if @size?
      ratio = @size / @data.size
      canvas.height *= ratio
      canvas.width *= ratio
      context.scale ratio, ratio

    offset = 0

    text.map (i, c) =>
      @getCharSprite c

    .forEach (charSprite, i) =>
      charData = @data.chars[text.charAt(i)]

      if noOffsets
        charSprite.draw context, offset
      else
        charSprite.draw context, offset + charData.offset.x, charData.offset.y

      if noSpaces
        offset += charSprite.width
      else
        offset += charData.width

      if @color
        overlayCanvas = doc.newEl "canvas"
        overlayContext = overlayCanvas.getContext "2d"
        overlayCanvas.width = width
        overlayCanvas.height = height
        overlayContext.beginPath()
        overlayContext.rect 0, 0, width, height
        overlayContext.fillStyle = @color
        overlayContext.fill()

        context.save()
        context.globalCompositeOperation = "source-in"
        context.drawImage overlayCanvas, 0, 0
        context.restore()

    canvas

  getCharSprite: (char) ->
    return @charSpritesMap[char] if @charSpritesMap[char]?

    {x, y, width, height} = @data.chars[char].rect
    canvas = doc.newEl "canvas"
    context = canvas.getContext "2d"
    canvas.width = width
    canvas.height = height
    context.drawImage @atlas, x, y, width, height, 0, 0, width, height

    @charSpritesMap[char] = new Engine.Sprite canvas

  Object.defineProperties @proto,
    "src":
      set: (src) ->
        @__defineGetter__ "src", -> src
        done = _.after 2, @onload if @onload?

        @atlas = new Image
        @atlas.onload = done
        @atlas.src = "#{src}.png"

        $.getJSON "#{src}.json", (@data) =>
          done?()
    
