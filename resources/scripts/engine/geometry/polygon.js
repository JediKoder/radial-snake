Engine.Geometry.Polygon = class Polygon {
  constructor(...bounds) {
    this.bounds = bounds.map(coords => new Engine.Geometry.Line(...coords));
  }

  hasPoint(x, y) {
    return this.bounds.some(bound => bound.hasPoint(x, y));
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
    let result = this.bounds.reduce((result, bound) => {
      let intersection = line.getLineIntersection(bound);
      if (intersection) result = result.concat(intersection);
      return result;
    }, []);

    if (result.length) return result;
  }

  getCircleIntersection(circle) {
    let result = this.bounds.reduce((result, bound) => {
      let intersection = circle.getLineIntersection(bound);
      if (intersection) result = result.concat(intersection);
      return result;
    }, []);

    if (result.length) return result;
  }

  getPolygonIntersection(polygon) {
    let result = this.bounds.reduce((result, bound) => {
      let intersection = polygon.getLineIntersection(bound);
      if (intersection) result = result.concat(intersection);
      return result;
    }, []);

    if (result.length) return result;
  }
};