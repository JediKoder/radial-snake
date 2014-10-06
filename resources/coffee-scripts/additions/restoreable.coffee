class @Restoreable
  constructor: (@restoreableProps...) ->
    @restoreableStates = []

  save: ->
    @restoreableStates.push @restoreableProps.reduce (state, prop) =>
      state[prop] = @[prop]
      state
    , {}

  restore: ->
    _(this).extend @restoreableStates.pop()