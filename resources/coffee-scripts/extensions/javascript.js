HTMLDocument.prototype.newEl = HTMLDocument.prototype.createElement;

Object.renew = function(obj, constructor, ...args) {
  constructor.call(obj, ...args);
  obj.constructor = constructor;
  return obj.__proto__ = constructor.prototype;
};

Object.defineProperties(self, {
  "callee": {
    get() {
      return arguments.callee.caller;
    }
  },

  "args": {
    get() {
      return arguments.callee.caller.arguments;
    }
  },

  "caller": {
    get() {
      return arguments.callee.caller.caller;
    }
  },

  "doc": {
    get() {
      return document;
    }
  }
});

Object.defineProperties(Object.prototype, {
  "proto": {
    get() {
      return this.prototype;
    }
  },

  "getProperty": {
    value(...keys) {
      let prop = this;

      keys.forEach(k => prop = prop[k]);

      return prop;
    }
  },

  "setProperty": {
    value(...keys) {
      let value = keys.pop();
      let dstKey = keys.pop();
      let srcProp = this.getProperty(...keys);
      return srcProp[dstKey] = value;
    }
  },

  "forEach": {
    value(iterator) {
      for (let k in this) {
        let v = this[k];
        if (this.hasOwnProperty(k)) {
          iterator(k, v, this);
        }
      }
    }
  },

  "map": {
    value(iterator) {
      let map = [];

      for (let k in this) {
        let v = this[k];
        if (this.hasOwnProperty(k)) {
          map.push(iterator(k, v, this));
        }
      }

      return map;
    }
  }
});

Object.defineProperties(Array.prototype, {
  "common": {
    value(iterator) {
      iterator = iterator || ((a, b) => a === b);

      let common = [];

      for (let i = 0; i < this.length; i++) {
        for (let j = i + 1; j < this.length; j++) {
          if (iterator(this[j], this[i])) common.push(this[j]);
        }
      }

      return common;
    }
  }
});

Object.defineProperties(Number.prototype, {
  "trim": {
    value(decimals, mode = "round") {
      return Math[mode](this * Math.pow(10, decimals)) / Math.pow(10, decimals);
    }
  },

  "isBetween": {
    value(num1, num2, percision) {
      return this.compare(Math.min(num1, num2), ">=", percision) &&
      this.compare(Math.max(num1, num2), "<=", percision);
    }
  },

  "compare": {
    value(num) {
      switch (arguments.length) {
        case 2:
          var percision = arguments[1];
          break;
        case 3:
          var method = arguments[1];
          percision = arguments[2];
          break;
      }

      switch (percision) {
        case "f":
          switch (method) {
            case "<": case "<=": return this <= num + Number.EPSILON;
            case ">": case ">=": return this >= num - Number.EPSILON;
            default: return Math.abs(this - num) <= Number.EPSILON;
          }
        case "px":
          switch (method) {
            case "<": case "<=": return Math.round(this) <= Math.round(num);
            case ">": case ">=": return Math.round(this) >= Math.round(num);
            default: return Math.round(this) === Math.round(num);
          }
        default:
          switch (method) {
            case "<": return this < num;
            case "<=": return this <= num;
            case ">": return this > num;
            case ">=": return this >= num;
            default: return this === num;
          }
      }
    }
  }
});
