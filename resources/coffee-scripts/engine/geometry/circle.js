Engine.Geometry.Circle = class Circle {
  constructor(x, y, r, rad1, rad2) {
    this.x = x.trim(9);
    this.y = y.trim(9);
    this.r = r.trim(9);

    if (rad1 > rad2) {
      this.rad1 = rad1.trim(9, "floor");
      this.rad2 = rad2.trim(9, "ceil");
    } else {
      this.rad1 = rad1.trim(9, "ceil");
      this.rad2 = rad2.trim(9, "floor");
    }
  }

  getX(rad) {
    if (!rad.isBetween(this.rad1, this.rad2)) return;
    return ((this.r * Math.cos(rad)) + this.x).trim(9);
  }

  getY(rad) {
    if (!rad.isBetween(this.rad1, this.rad2)) return;
    return ((this.r * Math.sin(rad)) + this.y).trim(9);
  }

  getPoint(rad) {
    if (!rad.isBetween(this.rad1, this.rad2)) return;
    return {
      x: ((this.r * Math.cos(rad)) + this.x).trim(9),
      y: ((this.r * Math.sin(rad)) + this.y).trim(9)
    };
  }

  getRad(x, y) {
    let rad = Math.atan2(y - this.y, x - this.x);

    if (rad && rad.isBetween(this.rad1, this.rad2)) {
      return rad;
    }

    if (Math.abs(this.rad1) > Math.abs(this.rad2)) {
      var cycRad = this.rad1;
    }
    else {
      var cycRad = this.rad2;
    }

    if ((rad + (2 * Math.PI * Math.floor(cycRad / (2 * Math.PI)))).trim(9).isBetween(this.rad1, this.rad2) ||
       (rad + (2 * Math.PI * Math.ceil(cycRad / (2 * Math.PI)))).trim(9).isBetween(this.rad1, this.rad2)) {
      return rad;
    }
  }

  hasPoint(x, y) {
    return !!this.getRad(x, y);
  }

  getCircleIntersection(c) {
    let dx = c.x - this.x;
    let dy = c.y - this.y;
    let d = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));

    if (d > this.r + c.r ||
       d < Math.abs(this.r - c.r)) {
      return;
    }

    let a = ((Math.pow(this.r, 2) - Math.pow(c.r, 2)) + Math.pow(d, 2)) / (2 * d);
    let x = this.x + ((dx * a) / d);
    let y = this.y + ((dy * a) / d);
    let h = Math.sqrt(Math.pow(this.r, 2) - Math.pow(a, 2));
    let rx = (- dy * h) / d;
    let ry = (dx * h) / d;

    let interPoints = [
      {
        x: x + rx,
        y: y + ry
      },
      {
        x: x - rx,
        y: y - ry
      }
    ]
    .map(p => ({
        x: p.x.trim(9),
        y: p.y.trim(9)
     }));

    interPoints = _.uniq(interPoints, p => `(${p.x}, ${p.y})`);

    [this, c].forEach(function(c) {
      interPoints = interPoints.filter(p => c.hasPoint(p.x, p.y));
    });

    if (interPoints.length > 0) return interPoints;
  }

  getLineIntersection(l) {
    let x1 = l.x1 - this.x;
    let x2 = l.x2 - this.x;
    let y1 = l.y1 - this.y;
    let y2 = l.y2 - this.y;
    let dx = x2 - x1;
    let dy = y2 - y1;
    let d = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));
    let h = (x1 * y2) - (x2 * y1);
    let delta = (Math.pow(this.r, 2) * Math.pow(d, 2)) - Math.pow(h, 2);

    if (delta < 0) return;

    let interPoints = [
      {
        x: (((h * dy) + (((dy / Math.abs(dy)) || 1) * dx * Math.sqrt(delta))) / Math.pow(d, 2)) + this.x,
        y: (((-h * dx) + (Math.abs(dy) * Math.sqrt(delta))) / Math.pow(d, 2)) + this.y
      },
      {
        x: (((h * dy) - (((dy / Math.abs(dy)) || 1) * dx * Math.sqrt(delta))) / Math.pow(d, 2)) + this.x,
        y: (((-h * dx) - (Math.abs(dy) * Math.sqrt(delta))) / Math.pow(d, 2)) + this.y
      }
    ]
    .map(p => ({
        x: p.x.trim(9),
        y: p.y.trim(9)
    }))
    .filter(p => {
      return this.hasPoint(p.x, p.y) &&
        l.boundsHasPoint(p.x, p.y);
    });

    interPoints = _.uniq(interPoints, p => `(${p.x}, ${p.y})`);

    if (interPoints.length > 0) return interPoints;
  }
};