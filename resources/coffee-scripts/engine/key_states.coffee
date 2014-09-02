class Engine.KeyStates
  constructor: ->
    @states = new Array 255

  get: (k) ->
    @states[k]

  add: (k) ->
    @states[k] = on

  remove: (k) ->
    @states[k] = off