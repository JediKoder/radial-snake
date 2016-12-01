Engine.Sprite = class Sprite {
  constructor(texture) {
    this.texture = texture;
    this.x = 0;
    this.y = 0;
    this.width = texture.width;
    this.height = texture.height;
    this.pivot = {x: 0, y: 0};
    this.opacity = 1;
  }

  draw(context, offsetX = 0, offsetY = 0) {
    context.save();
    context.globalAlpha = this.opacity;

    switch (this.align) {
      case "top-left": case "left-top": this.pivot = {x: 0, y: 0}; break;
      case "top-right": case "right-top": this.pivot = {x: this.width, y: 0}; break;
      case "bottom-left": case "left-bottom": this.pivot = {x: 0, y: this.height}; break;
      case "bottom-right": case "right-bottom": this.pivot = {x: this.width, y: this.height}; break;
      case "middle": case "center": this.pivot = {x: this.width / 2, y: this.height / 2}; break;
      case "left": this.pivot = {x: 0, y: this.height / 2}; break;
      case "top": this.pivot = {x: this.width / 2, y: 0}; break;
      case "right": this.pivot = {x: this.width, y: this.height / 2}; break;
      case "bottom": this.pivot = {x: this.width / 2, y: this.height}; break;
    }

    context.drawImage(
      this.texture,
      (this.x - this.pivot.x) + offsetX,
      (this.y - this.pivot.y) + offsetY,
      this.width,
      this.height
    );

    context.restore();
  }

  setPercentage(key, relative, percents, ...adapters) {
    let oldVal = this[key];
    let newVal = this[key] = (percents * relative) / 100;
    let ratio = newVal / oldVal;

    adapters.forEach(adapter => {
      this[adapter] *= ratio;
    });
  }
};