Object.defineProperties self,
  "doc":
    get: ->
      document
  ,
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

  "setProperty":
    enumerable: no
    value: (keys..., value) ->
      dstKey = keys.pop()
      srcProp = @getProperty keys...
      srcProp[dstKey] = value

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
      iterator ?= (a, b) ->
        a is b

      common = []

      for i in [0...@length]
        for j in [i + 1...@length]
          common.push @[j] if iterator @[j], @[i]

      common

Object.defineProperties Number.prototype,
  "trim":
    enumerable: no
    value: (decimals, mode = "round") ->
      Math[mode](this * Math.pow(10, decimals)) / Math.pow(10, decimals)

  "isBetween":
    enumerable: no
    value: (num1, num2, percision) ->
      this.compare(Math.min(num1, num2), ">=", percision) and
      this.compare(Math.max(num1, num2), "<=", percision)

  "compare":
    enumerable: no
    value: (num) ->
      switch args.length
        when 2
          percision = args[1]
        when 3
          method = args[1]
          percision = args[2]

      switch percision
        when "f"
          switch method
            when "<", "<=" then this <= num + Number.EPSILON
            when ">", ">=" then this >= num - Number.EPSILON
            else Math.abs(this - num) <= Number.EPSILON
        when "px"
          switch method
            when "<", "<=" then Math.round(this) <= Math.round(num)
            when ">", ">=" then Math.round(this) >= Math.round(num)
            else Math.round(this) is Math.round(num)
        else
          switch method
            when "<" then this < num
            when "<=" then this <= num
            when ">" then this > num
            when ">=" then this >= num
            else this is num
      