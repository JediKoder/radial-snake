class Engine.Font
  constructor: ->
    src = undefined
    @sprites = {}

    Object.defineProperty this, "src"
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

  createTexture: (text) ->
    canvas = doc.createElement "canvas"
    context = canvas.getContext "2d"
    canvas.height = @data.height

    canvas.width = _.reduce text, (width, char) =>
      width + @data.chars[char].width
    , 0

    offset = 0

    text.map (i, c) =>
      @get c

    .forEach (sprite, i) =>
      char = @data.chars[text.charAt(i)]
      sprite.draw context, offset + char.offset.x, char.offset.y
      offset += char.width

    canvas

  get: (char) ->
    return @sprites[char] if @sprites[char]?

    {x, y, width, height} = @data.chars[char].rect
    canvas = doc.createElement "canvas"
    context = canvas.getContext "2d"
    canvas.width = width
    canvas.height = height
    context.drawImage @atlas, x, y, width, height, 0, 0, width, height

    @sprites[char] = new Engine.Sprite canvas
