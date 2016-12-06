Game.Entities.Snake = class Snake {
  constructor(x, y, r, rad, v, color, keyStates, options) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.rad = rad;
    this.v = v;
    this.color = color;
    this.keyStates = keyStates;
    this.shapes = [];
    this.currShape = new Engine.Geometry.Line(x, y, x, y);
    this.shapes.push(this.currShape);
    this.score = options.score || 0;

    if (options.keys && options.keys) {
      this.leftKey = options.keys.left;
      this.rightKey = options.keys.right;
    }
    else {
      this.leftKey = 37; // Left arrow
      this.rightKey = 39; // Right arrow
    }
  }

  draw(context) {
    this.shapes.forEach(shape => {
      context.save();
      context.strokeStyle = this.color;
      context.lineWidth = 3;
      context.beginPath();

      if (shape instanceof Engine.Geometry.Line) {
        context.moveTo(shape.x1, shape.y1);
        context.lineTo(shape.x2, shape.y2);
      }
      else {
        context.arc(shape.x, shape.y, shape.r, shape.rad1, shape.rad2);
      }

      context.stroke();
      context.restore();
    });
  }

  update(span, width, height) {
    let step = (this.v * span) / 1000;

    this.updateShapes(step, width, height);
    this.cycleThrough(step, width, height);
  }

  updateShapes(step, width, height, options = {}) {
    if (this.currShape instanceof Engine.Geometry.Line) {
      let lastX = options.lastX || this.x;
      let lastY = options.lastY || this.y;
      this.x = options.x || this.currShape.x2;
      this.y = options.y || this.currShape.y2;
      this.lastBit = new Engine.Geometry.Line(lastX, lastY, this.x, this.y);
    }
    else {
      let lastX = options.lastX || this.currShape.x;
      let lastY = options.lastY || this.currShape.y;
      let lastR = options.lastR || this.currShape.r;

      if (this.direction == "left") {
        let lastRad = this.rad + (0.5 * Math.PI);
        let currShapePoint = this.currShape.getPoint(this.currShape.rad1);
        this.x = options.x || currShapePoint.x;
        this.y = options.y || currShapePoint.y;
        this.rad = this.currShape.rad1 - (0.5 * Math.PI);
        this.lastBit = new Engine.Geometry.Circle(lastX, lastY, lastR, this.currShape.rad1, lastRad);
      }
      else {
        let lastRad = this.rad - (0.5 * Math.PI);
        let currShapePoint = this.currShape.getPoint(this.currShape.rad2);
        this.x = options.x || currShapePoint.x;
        this.y = options.y || currShapePoint.y;
        this.rad = this.currShape.rad2 + (0.5 * Math.PI);
        this.lastBit = new Engine.Geometry.Circle(lastX, lastY, lastR, lastRad, this.currShape.rad2);
      }
    }

    if (this.keyStates.get(this.leftKey))
      var direction = "left";
    else if (this.keyStates.get(this.rightKey))
      var direction = "right";

    if (direction != this.direction || options.force) {
      this.direction = direction;

      let angle;
      let rad;
      let x;
      let y;

      switch (direction) {
        case "left":
          angle = this.rad - (0.5 * Math.PI);
          rad = this.rad + (0.5 * Math.PI);
          x = this.x + (this.r * Math.cos(angle));
          y = this.y + (this.r * Math.sin(angle));
          this.currShape = new Engine.Geometry.Circle(x, y, this.r, rad, rad);
          break;
        case "right":
          angle = this.rad + (0.5 * Math.PI);
          rad = this.rad - (0.5 * Math.PI);
          x = this.x + (this.r * Math.cos(angle));
          y = this.y + (this.r * Math.sin(angle));
          this.currShape = new Engine.Geometry.Circle(x, y, this.r, rad, rad);
          break;
        default:
          this.currShape = new Engine.Geometry.Line(this.x, this.y, this.x, this.y);
      }

      this.shapes.push(this.currShape);
    }

    switch (direction) {
      case "left":
        this.currShape.rad1 -= step / this.r;
        break;
      case "right":
        this.currShape.rad2 += step / this.r;
        break;
      default:
        this.currShape.x2 += step * Math.cos(this.rad);
        this.currShape.y2 += step * Math.sin(this.rad);
    }
  }

  cycleThrough(step, width, height) {
    let intersectionPoint = this.getCanvasIntersection(width, height);
    if (!intersectionPoint) return;

    intersectionPoint = intersectionPoint[0];
    let { x, y } = this;

    if (intersectionPoint.x == 0)
      x += width;
    else if (intersectionPoint.x == width)
      x -= width;

    if (intersectionPoint.y == 0)
      y += height;
    else if (intersectionPoint.y == height)
      y -= height;

    this.updateShapes(step, width, height, {
      force: true,
      lastX: x,
      lastY: y,
      x: x,
      y: y
    });
  }

  getSelfIntersection() {
    if (this.currShape instanceof Engine.Geometry.Circle &&
       Math.abs(this.currShape.rad1 - this.currShape.rad2) >= 2 * Math.PI) {
      if (this.direction == "left")
        var rad = this.currShape.rad1;
      else
        var rad = this.currShape.rad2;

      return this.currShape.getPoint(rad);
    }

    let result;

    this.shapes.slice(0, -2).some(shape =>
      result = this.lastBit.getIntersection(shape)
    );

    return result;
  }

  getSnakeIntersection(snake) {
    let result;

    snake.shapes.some(shape =>
      result = this.lastBit.getIntersection(shape)
    );

    return result;
  }

  getCanvasIntersection(width, height) {
    // canvas polygon
    let canvasPolygon = new Engine.Geometry.Polygon(
      [0, 0, width, 0],
      [width, 0, width, height],
      [width, height, 0, height],
      [0, height, 0, 0]
    );

    return canvasPolygon.getIntersection(this.lastBit);
  }
};