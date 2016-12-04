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
            default: return Math.round(this) == Math.round(num);
          }
        default:
          switch (method) {
            case "<": return this < num;
            case "<=": return this <= num;
            case ">": return this > num;
            case ">=": return this >= num;
            default: return this == num;
          }
      }
    }
  }
});
