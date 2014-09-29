SnakeOnline.Screens.Game::readyState =
  events:
    "keydown": "onKeyDown"

  initialize: -> 
    @readySprite.align = "center"
    @readySprite.setPercentage "width", @width, 15, "height"
    @readySprite.location = x: @width / 2, y: @height / 2

    @readyAnim = new Engine.Animations.Keyframe @readySprite, [
      location: x: @width / 2, y: @height / 2
      opacity: 1
      frame: 0
    ,
      location: x: @width / 2, y: @height / 3
      opacity: 0
      frame: 700
    ]

  draw: (context) ->
    @readySprite.draw context

  update: (span) ->
    return on unless @ready

    unless @hasStateActivated "play"
      @readyAnim.playing = yes
      @prependState "play"

    @readyAnim.update span
    return on if @readyAnim.playing
    
    off

  onKeyDown: ->
    @ready = yes