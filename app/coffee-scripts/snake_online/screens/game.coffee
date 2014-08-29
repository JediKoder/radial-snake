class SnakeOnline.Screens.Game extends Engine.Screen
  constructor: (game) ->
    super game
    @readyText = new Engine.Text "READY", "50pt Minecraftia"
    @readyText.location = x: @width / 2, y: @height / 2
    @readyText.align = "center"
    @readyText.color = "white"
    @setState "ready"

  draw: (context) ->
    super context

    switch @state
      when "ready"
        @readyText.draw context

      when "play"
        # TODO: Insert play draw logic
        break

  update: ->
    switch @state
      when "ready"
        @setState "play" if @ready

      when "play"
        # TODO: Insert play update logic
        break

    this

  setState: (state) ->
    switch @state
      when "ready"
        @game.removeEventListener "keydown", @onReadyKeyDown

    switch state
      when "ready"
        @game.addEventListener "keydown", @onReadyKeyDown, this

      when "play"
        # TODO: Insert play state logic
        break

    @state = state

  onReadyKeyDown: ->
    @ready = yes