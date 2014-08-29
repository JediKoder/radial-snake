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

Number::isInRange = (range, isFloat) ->
  min = _.min range
  max = _.max range

  if isFloat
    this.floatCompare(min, ">") and
    this.floatCompare(max, "<")
  else
    this >= min and this <= max

Number::floatCompare = (f, method) ->
  switch method
    when "<" then this <= f + Number.EPSILON
    when ">" then this >= f - Number.EPSILON
    else Math.abs(this - f) < Number.EPSILON

Array::common = (iterator) ->
  common = []

  for i in [0...@length]
    for j in [i + 1...@length]
      if iterator?
        common.push @[j] if iterator @[j], @[i]
      else
        common.push @[j] if @[j] is @[i]

  common