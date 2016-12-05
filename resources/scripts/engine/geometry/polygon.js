Engine.Geometry.Polygon = class Polygon {
  constructor(...bounds) {
    this.bounds = bounds;
  }

  hasPoint(x, y) {
    let result;
    this.bounds.some(bound => result = bound.hasPoint(x, y));
    return result;
  }

  getIntersection(shape) {
    if (shape instanceof Engine.Geometry.Line)
      return this.getLineIntersection(shape);
    if (shape instanceof Engine.Geometry.Circle)
      return this.getCircleIntersection(shape);
    if (shape instanceof Engine.Geometry.Polygon)
      return this.getPolygonIntersection(shape);
  }

  getLineIntersection(l) {
    let result;
    this.bounds.some(b => result = l.getLineIntersection(b));
    return result && [].concat(result);
  }

  getCircleIntersection(c) {
    let result;
    this.bounds.some(b => result = c.getLineIntersection(b));
    return result && [].concat(result);
  }

  getPolygonIntersection(p) {
    let result;
    this.bounds.some(b => result = p.getLineIntersection(b));
    return result && [].concat(result);
  }
};