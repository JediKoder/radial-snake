class Engine.Screens.Statable extends Engine.Screen
  constructor: (game, assets) ->
    super game, assets

    @states = @states.map (name, state) =>
      state = if typeof state is "string"
        @[state]
      else
        state

      state.name = name
      state

    @activeStates = []

  draw: (context) ->
    super context
    @activeStates.forEach (state) =>
      state.draw?.call this, context

  update: (span) ->
    garbage = []

    @activeStates.forEach (state, i) =>
      garbage.push i if !state.update?.call(this, span)

    garbage.forEach (i) =>
      @removeStateEventListeners @activeStates.splice(i, 1)[0]

    return this unless @newScreen?

    @activeStates.forEach (state) =>
      @removeStateEventListeners state

    @newScreen

  addStateEventListeners: (state) ->
    state.events?.forEach (event) =>
      @game.addEventListener event, @getEventListener.call(state, event), this

  removeStateEventListeners: (state) ->
    state.events?.forEach (event) =>
      @game.removeEventListener event, @getEventListener.call(state, event)

  appendState: (name) ->
    return if @hasStateActivated name
    state = @getState name
    @activeStates.push state
    @addStateEventListeners state
    state.initialize?.call this

  prependState: (name) ->
    return if @hasStateActivated name
    state = @getState name
    @activeStates.unshift state
    @addStateEventListeners state
    state.initialize?.call this

  hasStateActivated: (name) ->
    _.pluck(@activeStates, "name").indexOf(name) isnt -1

  getState: (name) ->
    _.find @states, (state) -> state.name is name