Object.defineProperties self,
  "args":
    get: ->
      arguments.callee.caller.arguments
  ,
  "caller":
    get: ->
      arguments.callee.caller.caller
  ,
  "callee":
    get: ->
      arguments.callee.caller

Object.defineProperties Object.prototype,
  "getProperty":
    enumerable: no
    value: (keys...) ->
      prop = this

      keys.forEach (k) ->
        prop = prop[k]

      prop

  "forEach":
    enumerable: no
    value: (iterator) ->
      for k, v of this
        if @hasOwnProperty(k)
          iterator k, v, this

  "map":
    enumerable: no
    value: (iterator) ->
      map = []

      @forEach (k, v, obj) ->
        map.push iterator(k, v, obj)

      map

Object.defineProperties Array.prototype,
  "common":
    enumerable: no
    value: (iterator) ->
      common = []

      for i in [0...@length]
        for j in [i + 1...@length]
          if iterator?
            common.push @[j] if iterator @[j], @[i]
          else
            common.push @[j] if @[j] is @[i]

      common

Object.defineProperties Number.prototype,
  "isBetween":
    enumerable: no
    value: (num1, num2, isFloat) ->
      min = Math.min num1, num2
      max = Math.max num1, num2

      if isFloat
        this.compare(min, ">") and
        this.compare(max, "<")
      else
        this >= min and this <= max

  "compare":
    enumerable: no
    value: (number, method) ->
      switch method
        when "<" then this <= number + Number.EPSILON
        when ">" then this >= number - Number.EPSILON
        else Math.abs(this - number) <= Number.EPSILON