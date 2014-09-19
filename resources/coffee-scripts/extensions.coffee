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
    value: (num1, num2, percision) ->
      this.compare(Math.min(num1, num2), ">", percision) and
      this.compare(Math.max(num1, num2), "<", percision)

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
        when "float"
          switch method
            when "<", "<=" then this <= num + 2 * Number.EPSILON
            when ">", ">=" then this >= num + 2 * Number.EPSILON
            else Math.abs(this - num) <= 2 * Number.EPSILON
        when "pixel"
          switch method
            when "<", "<=" then Math.round(this) <= Math.round(num)
            when ">", ">=" then Math.round(this) >= Math.round(num)
            else Math.round(this) is Math.round(num)
        else
          switch
            when then "<" this < num
            when then "<=" this <= num
            when then ">" this > num
            when then ">=" this >= num
            else this is num
      