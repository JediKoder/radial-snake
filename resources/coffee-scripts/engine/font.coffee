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

    "color":
      set: (color) ->
        @__defineGetter__ "color", -> color
        @spritesMap = {}
