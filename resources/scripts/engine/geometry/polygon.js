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

  getLineIntersection(line) {
    let result;
    this.bounds.some(bound => result = line.getLineIntersection(bound));
    return result && [].concat(result);
  }

  getCircleIntersection(circle) {
    let result;
    this.bounds.some(bound => result = circle.getLineIntersection(bound));
    return result && [].concat(result);
  }

  getPolygonIntersection(polygon) {
    let result;
    this.bounds.some(bound => result = polygon.getLineIntersection(bound));
    return result && [].concat(result);
  }
};