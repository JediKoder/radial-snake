DOMParser = require("xmldom").DOMParser
Async = require "async"
Fs = require "fs"
_ = require "underscore"

exports.xmlToJSON = (path, callback) ->
  Async.waterfall [
    (next) -> Fs.readFile "#{path}.xml", (err, xmlBuf) ->
      return next err if err

      jsonObj = 
        chars: {}

      xml = xmlBuf.toString()
      doc = new DOMParser().parseFromString xml
      fontDoc = doc.getElementsByTagName("Font")[0]
      charsDoc = fontDoc.getElementsByTagName "Char"

      _(fontDoc.attributes).each (attr) ->
        jsonObj[attr.name] = parseInt(attr.value) || attr.value

      _(charsDoc).each (charDoc) ->
        charCode = charDoc.getAttribute "code"

        char = jsonObj.chars[charCode] =
          rect: rect = {}
          offset: offset = {}
          width: parseInt charDoc.getAttribute("width")

        [rect.x
         rect.y
         rect.width
         rect.height] = extractIntegers charDoc.getAttribute("rect")

        [offset.x
         offset.y] = extractIntegers charDoc.getAttribute("offset")

      next null, JSON.stringify(jsonObj, null, 2)

    (json, done) -> Fs.writeFile "#{path}.json", json, (err) ->
      done err

  ], (err) ->
    callback? err

extractIntegers = (srcstr) ->
  srcstr.split(" ").map (substr) ->
    parseInt substr