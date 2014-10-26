HTMLDocument::newEl = HTMLDocument::createElement

Object.renew = (obj, constructor, args...) ->
  constructor.call obj, args...
  obj.constructor = constructor
  obj.__proto__ = constructor.prototype

Object.defineProperties self,
  "callee":
    get: ->
      arguments.callee.caller
  ,
  "args":
    get: ->
      arguments.callee.caller.arguments
  ,
  "caller":
    get: ->
      arguments.callee.caller.caller
  ,
  "doc":
    get: ->
      document

Object.defineProperties Object.prototype,
  "proto":
    get: ->
      @prototype

  "getProperty":
    value: (keys...) ->
      prop = this

      keys.forEach (k) ->
        prop = prop[k]

      prop

  "setProperty":
    value: (keys..., value) ->
      dstKey = keys.pop()
      srcProp = @getProperty keys...
      srcProp[dstKey] = value

  "forEach":
    value: (iterator) ->
      for k, v of this
        if @hasOwnProperty(k)
          iterator k, v, this

  "map":
    value: (iterator) ->
      map = []

      for k, v of this
        if @hasOwnProperty(k)
          map.push iterator(k, v, this)

      map

Object.defineProperties Array.prototype,
  "common":
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
    value: (decimals, mode = "round") ->
      Math[mode](this * Math.pow(10, decimals)) / Math.pow(10, decimals)

  "isBetween":
    value: (num1, num2, percision) ->
      this.compare(Math.min(num1, num2), ">=", percision) and
      this.compare(Math.max(num1, num2), "<=", percision)

  "compare":
    value: (num) ->
      switch arguments.length
        when 2
          percision = arguments[1]
        when 3
          method = arguments[1]
          percision = arguments[2]

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