class Engine.Screens.Statable extends Engine.Screen
  constructor: (game, state) ->
    super game
    @initedStates = []
    @setState state
    @addStateEventListeners()

  draw: (context) ->
    super context
    @state.draw?.call this, context

  update: (span) ->
    @state.update?.call this, span

  setState: (state) ->
    @removeStateEventListeners() if @state?
    @state = @getStateHandler state
    @addStateEventListeners()
    return unless @initedStates.indexOf(state) is -1 

    @state.initialize.call this
    @initedStates.push state

  addStateEventListeners: ->
    @state.events?.forEach (event) =>
      @game.addEventListener event, @getEventListener.call(@state, event), this

  removeStateEventListeners: ->
    @state.events?.forEach (event) =>
      @game.removeEventListener event, @getEventListener.call(@state, event)

  getStateHandler: (state) ->
    handler = @states[state]

    if typeof handler is "string"
      @[handler]
    else
      handler