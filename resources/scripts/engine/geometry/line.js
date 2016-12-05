Engine.Geometry.Line = class Line {
  constructor(x1, y1, x2, y2) {
    this.x1 = x1.trim(9);
    this.y1 = y1.trim(9);
    this.x2 = x2.trim(9);
    this.y2 = y2.trim(9);
  }

  getX(y) {
    let x = ((((y - this.y1) * (this.x2 - this.x1)) / (this.y2 - this.y1)) + this.x1).trim(9);
    if (isNaN(x) || x.isBetween(this.x1, this.x2)) return x;
  }

  getY(x) {
    let y = ((((x - this.x1) * (this.y2 - this.y1)) / (this.x2 - this.x1)) + this.y1).trim(9);
    if (isNaN(y) || y.isBetween(this.y1, this.y2)) return y;
  }

  hasPoint(x, y) {
    if (!this.boundsHavePoint(x, y)) return false;
    let m = ((this.y2 - this.y1) / (this.x2 - this.x1)).trim(9);
    return y - this.y1 == m * (x - this.x1);
  }

  boundsHavePoint(x, y) {
    return x.isBetween(this.x1, this.x2) &&
    y.isBetween(this.y1, this.y2);
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
    if (!(((this.x1 - this.x2) * (l.y1 - l.y2)) - ((this.y1 - this.y2) * (l.x1 - l.x2)))) return;

    let x = (((((this.x1 * this.y2) - (this.y1 * this.x2)) * (l.x1 - l.x2)) - ((this.x1 - this.x2) * ((l.x1 * l.y2) - (l.y1 * l.x2)))) /
        (((this.x1 - this.x2) * (l.y1 - l.y2)) - ((this.y1 - this.y2) * (l.x1 - l.x2)))).trim(9);
    let y = (((((this.x1 * this.y2) - (this.y1 * this.x2)) * (l.y1 - l.y2)) - ((this.y1 - this.y2) * ((l.x1 * l.y2) - (l.y1 * l.x2)))) /
        (((this.x1 - this.x2) * (l.y1 - l.y2)) - ((this.y1 - this.y2) * (l.x1 - l.x2)))).trim(9);

    if (x.isBetween(this.x1, this.x2) && x.isBetween(l.x1, l.x2) &&
       y.isBetween(this.y1, this.y2) && y.isBetween(l.y1, l.y2)) {
      return { x, y };
    }
  }

  getCircleIntersection(c) {
    return c.getLineIntersection(this);
  }

  getPolygonIntersection(p) {
    return p.getLineIntersection(this);
  }
};