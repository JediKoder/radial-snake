class Engine.Screens.Statable extends Engine.Screen
  constructor: (game, assets) ->
    super game, assets
    @states = []

  draw: (context) ->
    super context
    @states.forEach (state) =>
      state.draw?.call this, context

  update: (span) ->
    garbage = []

    @states.forEach (state, i) =>
      garbage.push i if !state.update?.call(this, span)

    garbage.forEach (i) =>
      @removeStateEventListeners @states.splice(i, 1)[0]

    return this unless @newScreen?

    @states.forEach (state) =>
      @removeStateEventListeners state

    @newScreen

  addStateEventListeners: (state) ->
    state.events?.forEach (event) =>
      @game.addEventListener event, @getEventListener.call(state, event), this

  removeStateEventListeners: (state) ->
    state.events?.forEach (event) =>
      @game.removeEventListener event, @getEventListener.call(state, event)

  appendState: (name) ->
    state = @getState name
    @states.push state
    @addStateEventListeners state
    state.initialize?.call this

  prependState: (name) ->
    state = @getState name
    @states.unshift state
    @addStateEventListeners state
    state.initialize?.call this

  getState: (name) ->
    state = @__proto__.states[name]

    if typeof state is "string"
      @[state]
    else
      state