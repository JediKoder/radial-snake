class Engine.Sprites.Text extends Engine.Sprite
  constructor: (@text, @font) ->
    canvas = doc.createElement "canvas"
    context = canvas.getContext "2d"
    canvas.height = font.data.height

    canvas.width = _.reduce text, (width, char) ->
      width + font.data.chars[char].width
    , 0

    offset = 0

    text.map (i, c) ->
      font.get c

    .forEach (sprite, i) ->
      char = font.data.chars[text.charAt(i)]
      sprite.draw context, offset + char.offset.x, char.offset.y
      offset += char.width

    super canvas
