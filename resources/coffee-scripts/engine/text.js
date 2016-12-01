Engine.Text = class Text {
  constructor(text, font) {
    this.text = text;
    this.font = font;
    this.location = {x: 0, y: 0};
    this.opacity = 1;
    this.color = "white";
  }

  draw(context, offsetX = 0, offsetY = 0) {
    context.save();
    context.globalAlpha = this.opacity;
    context.fillStyle = this.color;
    context.font = this.font;
    context.textAlign = this.align;

    context.fillText(this.text,
      this.location.x + offsetX,
      this.location.y + offsetY);

    context.restore();
  }

  getMetrics(context) {
    context.save();
    context.font = this.font;
    let metrics = context.measureText(this.text);
    context.restore();
    return metrics;
  }
};