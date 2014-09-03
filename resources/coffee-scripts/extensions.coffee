Object.defineProperties self,
  "args":
    get: ->
      arguments.callee.caller.arguments
  ,
  "caller":
    get: ->
      arguments.callee.caller.caller
  ,
  "length":
    get: ->
      arguments.callee.caller.length
  ,
  "name":
    get: ->
      arguments.callee.caller.name
  ,
  "callee":
    get: ->
      arguments.callee.caller

Object::getProperty = (keys...) ->
  prop = this

  keys.forEach (k) ->
    prop = prop[k]

  prop

Object::forEach = (iterator) ->
  for k, v of this
    if @hasOwnProperty(k)
      iterator k, v, this

Array::common = (iterator) ->
  common = []

  for i in [0...@length]
    for j in [i + 1...@length]
      if iterator?
        common.push @[j] if iterator @[j], @[i]
      else
        common.push @[j] if @[j] is @[i]

  common

Number::isBetween = (num1, num2, isFloat) ->
  min = Math.min num1, num2
  max = Math.max num1, num2

  if isFloat
    this.compare(min, ">") and
    this.compare(max, "<")
  else
    this >= min and this <= max

Number::compare = (f, method) ->
  switch method
    when "<" then this <= f + Number.EPSILON
    when ">" then this >= f - Number.EPSILON
    else Math.abs(this - f) <= Number.EPSILON