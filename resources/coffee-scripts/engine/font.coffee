class Engine.Font
  constructor: ->
    @spritesMap = {}

  createTexture: (text, options) ->
    {noOffsets, noSpaces} = options if options?
    canvas = doc.newEl "canvas"
    context = canvas.getContext "2d"
    canvas.height = @data.height

    canvas.width = _.reduce text, (width, c) =>
      width + if noSpaces
        @get(c).width
      else
        @data.chars[c].width
    , 0

    offset = 0

    text.map (i, c) =>
      @get c

    .forEach (sprite, i) =>
      char = @data.chars[text.charAt(i)]

      if noOffsets
        sprite.draw context, offset
      else
        sprite.draw context, offset + char.offset.x, char.offset.y

      if noSpaces
        offset += sprite.width
      else
        offset += char.width

      if @color
        overlayCanvas = doc.newEl "canvas"
        overlayContext = overlayCanvas.getContext "2d"
        overlayCanvas.width = canvas.width
        overlayCanvas.height = canvas.height
        overlayContext.beginPath()
        overlayContext.rect 0, 0, canvas.width, canvas.height
        overlayContext.fillStyle = @color
        overlayContext.fill()

        context.save()
        context.globalCompositeOperation = "source-in"
        context.drawImage overlayCanvas, 0, 0
        context.restore()

    canvas

  get: (char) ->
    return @spritesMap[char] if @spritesMap[char]?

    {x, y, width, height} = @data.chars[char].rect
    canvas = doc.newEl "canvas"
    context = canvas.getContext "2d"
    canvas.width = width
    canvas.height = height
    context.drawImage @atlas, x, y, width, height, 0, 0, width, height

    @spritesMap[char] = new Engine.Sprite canvas

  @::__defineSetter__ "src", (src) ->
    @__defineGetter__ "src", -> src
    done = _.after 2, @onload if @onload?

    @atlas = new Image
    @atlas.onload = done
    @atlas.src = "#{src}.png"

    $.getJSON "#{src}.json", (@data) =>
      done?()
