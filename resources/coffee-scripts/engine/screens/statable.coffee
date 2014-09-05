class Engine.Screens.Statable extends Engine.Screen
  constructor: (game, state) ->
    super game

    @setState state
    @addStateEventListeners()

  draw: (context) ->
    super context
    @state.draw?.call this, context

  update: (span) ->
    @state.update?.call this, span

  setState: (name) ->
    @removeStateEventListeners()
    @state = @states[name]
    @addStateEventListeners()

  addStateEventListeners: ->
    @state.events?.forEach (event) =>
      @game.addEventListener event, @getEventListener.call(@state, event), this

  removeStateEventListeners: ->
    @state.events?.forEach (event) =>
      @game.removeEventListener event, @getEventListener.call(@state, event)

  setState: (state) ->
    @state = @getStateHandler state

  getStateHandler: (state) ->
    handler = @states[state]

    if typeof handler is "string"
      @[handler]
    else
      handler