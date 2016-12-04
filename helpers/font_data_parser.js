const _ = require("underscore");
const Async = require("async");
const Fs = require("fs");
const { DOMParser } = require("xmldom");

function xmlsToJsons(path, callback = _.noop) {
  Fs.readdir(path, (err, files) => {
    if (err) return callback(err);

    fileNames = _.uniq(files.map(file => file.split(".")[0]));

    Async.each(fileNames, (fileName, next) => {
      xmlToJson(`${path}/${fileName}`, next);
    },
    (err) => {
      callback(err);
    });
  });
}

function xmlToJson(path, callback = _.noop) {
  Async.waterfall([
    (next) => {
      Fs.readFile(`${path}.xml`, function(err, xmlBuf) {
        if (err) return next(err);

        let jsonObj = {
          chars: {}
        };

        let xml = xmlBuf.toString();
        let doc = new DOMParser().parseFromString(xml);
        let fontDoc = doc.getElementsByTagName("Font")[0];
        let charsDoc = fontDoc.getElementsByTagName("Char");

        _.each(fontDoc.attributes, (attr) => {
          jsonObj[attr.name] = parseInt(attr.value) || attr.value;
        });

        _.each(charsDoc, (charDoc) => {
          let charCode = charDoc.getAttribute("code");

          let char = jsonObj.chars[charCode] = {
            rect: rect = {},
            offset: offset = {},
            width: parseInt(charDoc.getAttribute("width"))
          };

          [
            rect.x,
            rect.y,
            rect.width,
            rect.height
          ] = extractIntegers(charDoc.getAttribute("rect"));

          [offset.x, offset.y] = extractIntegers(charDoc.getAttribute("offset"));
        });

        next(null, JSON.stringify(jsonObj, null, 2));
      });
    },
    (json, next) => {
      Fs.writeFile(path + ".json", json, (err) => {
        next(err);
      });
    }
  ], (err) => {
    callback(err);
  });
};

function extractIntegers(srcstr) {
  return srcstr.split(" ").map((substr) => parseInt(substr));
}

module.exports = {
  xmlToJson,
  xmlsToJsons
};