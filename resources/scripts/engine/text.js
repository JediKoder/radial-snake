Engine.Text = class Text {
  // An easy representation of a text on a canvas using a custom font
  constructor(text, font) {
    this.text = text;
    this.font = font;
    this.location = { x: 0, y: 0 };
    this.opacity = 1;
    this.color = "white";
  }

  // Draws the text
  draw(context, offsetX = 0, offsetY = 0) {
    context.save();
    context.globalAlpha = this.opacity;
    context.fillStyle = this.color;
    context.font = this.font;
    context.textAlign = this.align;

    context.fillText(
      this.text,
      this.location.x + offsetX,
      this.location.y + offsetY
    );

    context.restore();
  }

  // Gets the metrics of the text, based on its content, font, size etc
  getMetrics(context) {
    context.save();
    context.font = this.font;
    let metrics = context.measureText(this.text);
    context.restore();
    return metrics;
  }
};