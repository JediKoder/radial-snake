class @Restoreable
  constructor: (@_restoreableProps...) ->
    @_restoreableStates = []

  save: ->
    @_restoreableStates.push @_restoreableProps.reduce (state, prop) =>
      state[prop] = @[prop]
      state
    , {}

  restore: ->
    _(this).extend @_restoreableStates.pop()