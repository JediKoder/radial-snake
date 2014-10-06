class Engine.Font
  constructor: ->
    src = undefined
    @spriteMap = {}

    Object.defineProperty this, "src",
      get: ->
        src

      set: (url) ->
        src = url
        done = _.after 2, @onload if @onload?

        @atlas = new Image
        @atlas.onload = done
        @atlas.src = "#{src}.png"

        $.getJSON "#{src}.json", (@data) =>
          done?()

  createTexture: (text, options) ->
    {noOffsets, noSpaces} = options if options?
    canvas = doc.createElement "canvas"
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

    canvas

  get: (char) ->
    return @spriteMap[char] if @spriteMap[char]?

    {x, y, width, height} = @data.chars[char].rect
    canvas = doc.createElement "canvas"
    context = canvas.getContext "2d"
    canvas.width = width
    canvas.height = height
    context.drawImage @atlas, x, y, width, height, 0, 0, width, height

    @spriteMap[char] = new Engine.Sprite canvas
