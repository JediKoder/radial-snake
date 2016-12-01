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
    this.score = 0;

    if (options && options.keys) {
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
      } else {
        context.arc(shape.x, shape.y, shape.r, shape.rad1, shape.rad2);
      }

      context.stroke();
      context.restore();
    });
  }

  update(span) {
    let step = (this.v * span) / 1000;

    if (this.currShape instanceof Engine.Geometry.Line) {
      var { x: lastX, y: lastY } = this;
      this.x = this.currShape.x2;
      this.y = this.currShape.y2;
      this.lastBit = new Engine.Geometry.Line(lastX, lastY, this.x, this.y);
    } else {
      var { x: lastX, y: lastY, r: lastR } = this.currShape;

      if (this.direction === "left") {
        var lastRad = this.rad + (0.5 * Math.PI);
        ({ x: this.x, y: this.y } = this.currShape.getPoint(this.currShape.rad1));
        this.rad = this.currShape.rad1 - (0.5 * Math.PI);
        this.lastBit = new Engine.Geometry.Circle(lastX, lastY, lastR, this.currShape.rad1, lastRad);
      } else {
        var lastRad = this.rad - (0.5 * Math.PI);
        ({ x: this.x, y: this.y } = this.currShape.getPoint(this.currShape.rad2));
        this.rad = this.currShape.rad2 + (0.5 * Math.PI);
        this.lastBit = new Engine.Geometry.Circle(lastX, lastY, lastR, lastRad, this.currShape.rad2);
      }
    }

    if (this.keyStates.get(this.leftKey)) {
      var direction = "left";
    }
    else if (this.keyStates.get(this.rightKey)) {
      var direction = "right";
    }

    if (direction !== this.direction) {
      this.direction = direction;

      switch (direction) {
        case "left":
          let angle = this.rad - (0.5 * Math.PI);
          let rad = this.rad + (0.5 * Math.PI);
          let x = this.x + (this.r * Math.cos(angle));
          let y = this.y + (this.r * Math.sin(angle));
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
      case "right":
        this.currShape.rad2 += step / this.r;
      default:
        this.currShape.x2 += step * Math.cos(this.rad);
        this.currShape.y2 += step * Math.sin(this.rad);
    }
  }

  getSelfIntersection() {
    if (this.currShape instanceof Engine.Geometry.Circle &&
       Math.abs(this.currShape.rad1 - this.currShape.rad2) >= 2 * Math.PI) {
      let rad = this.direction == "left" ?
        this.currShape.rad1 :
        this.currShape.rad2;

      return this.currShape.getPoint(rad);
    }

    let result;

    this.shapes.slice(0, -2).some(s => {
      if (s instanceof Engine.Geometry.Line) {
        return result = this.lastBit.getLineIntersection(s);
      } else {
        return result = this.lastBit.getCircleIntersection(s);
      }
    });

    return result;
  }

  getSnakeIntersection(snake) {
    let result;

    snake.shapes.some(s => {
      if (s instanceof Engine.Geometry.Line) {
        return result = this.lastBit.getLineIntersection(s);
      } else {
        return result = this.lastBit.getCircleIntersection(s);
      }
    });

    return result;
  }
};