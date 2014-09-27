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

  get: (char) ->
    return @sprites[char] if @sprites[char]?

    {x, y, width, height} = @data.chars[char].rect
    canvas = doc.createElement "canvas"
    context = canvas.getContext "2d"
    canvas.width = width
    canvas.height = height
    context.drawImage @atlas, x, y, width, height, 0, 0, width, height

    @sprites[char] = new Engine.Sprite canvas
