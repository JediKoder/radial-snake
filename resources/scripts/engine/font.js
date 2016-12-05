Engine.Font = class Font extends Restorable {
  get src() {
    return this._src;
  }

  set src(src) {
    this._src = src;

    if (this.onload) var done = _.after(2, this.onload);

    this.atlas = new Image();
    this.atlas.onload = done;
    this.atlas.src = `${src}.png`;

    $.getJSON(`${src}.json`, data => {
      this.data = data;
      if (done) done();
    });

    return this._src;
  }

  constructor() {
    super("color");
    this.charSpritesMap = {};
  }

  createTexture(text, options = {}) {
    let { noOffsets, noSpaces } = options;
    let canvas = document.createElement("canvas");
    let context = canvas.getContext("2d");
    let height = canvas.height = this.data.height;

    let width = canvas.width = _.reduce(text, (width, c) => {
      if (noSpaces) {
        return width + this.getCharSprite(c).width;
      }

      return width + this.data.chars[c].width;
    }, 0);

    if (this.size) {
      let ratio = this.size / this.data.size;
      canvas.height *= ratio;
      canvas.width *= ratio;
      context.scale(ratio, ratio);
    }

    let offset = 0;

    _.map(text, (c, i) => {
      return this.getCharSprite(c);
    })
    .forEach((charSprite, i) => {
      let charData = this.data.chars[text.charAt(i)];

      if (noOffsets) {
        charSprite.draw(context, offset);
      }
      else {
        charSprite.draw(context, offset + charData.offset.x, charData.offset.y);
      }

      if (noSpaces) {
        offset += charSprite.width;
      }
      else {
        offset += charData.width;
      }

      if (this.color) {
        let overlayCanvas = document.createElement("canvas");
        let overlayContext = overlayCanvas.getContext("2d");
        overlayCanvas.width = width;
        overlayCanvas.height = height;
        overlayContext.beginPath();
        overlayContext.rect(0, 0, width, height);
        overlayContext.fillStyle = this.color;
        overlayContext.fill();

        context.save();
        context.globalCompositeOperation = "source-in";
        context.drawImage(overlayCanvas, 0, 0);
        context.restore();
      }
    });

    return canvas;
  }

  getCharSprite(char) {
    if (this.charSpritesMap[char]) return this.charSpritesMap[char];

    let { x, y, width, height } = this.data.chars[char].rect;
    let canvas = document.createElement("canvas");
    let context = canvas.getContext("2d");
    canvas.width = width;
    canvas.height = height;
    context.drawImage(this.atlas, x, y, width, height, 0, 0, width, height);

    return this.charSpritesMap[char] = new Engine.Sprite(canvas);
  }
};