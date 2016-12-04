Engine.Screen = class Screen {
  get width() {
    return this.game.canvas.width;
  }

  get height() {
    return this.game.canvas.height;
  }

  constructor(game) {
    this.game = game;
    this.age = 0;
    this.creation = new Date().getTime();
    this.assets = _.clone(game.assets);
    this.keyStates = game.keyStates;
    this.layers = [];
  }

  update(span) {
    this.layers.forEach(layer => {
      layer.age += span;
      if (layer.update) layer.update(span);
    });
  }

  draw(context) {
    this.layers.forEach(layer => layer.draw && layer.draw(context));
  }

  appendLayer(Layer, ...layerArgs) {
    let layer = new Layer(this, ...layerArgs);
    this.layers.push(layer);
    layer.initEventListeners();
  }

  prependLayer(Layer, ...layerArgs) {
    let layer = new Layer(this, ...layerArgs);
    this.layers.unshift(layer);
    layer.initEventListeners();
  }

  removeLayer(layer) {
    this.layers = _(this.layers).without(layer);
    layer.disposeEventListeners();
  }

  addEventListener(event, listener, target = this) {
    this.game.addEventListener(event, listener, target);
  }

  removeEventListener(event, listener) {
    this.game.removeEventListener(event, listener);
  }

  initEventListeners() {
    if (!this.events) return;

    this.events.forEach((event, listener) => {
      this.addEventListener(event, this[listener]);
    });
  }

  disposeEventListeners() {
    if (!this.events) return;

    this.events.forEach((event, listener) => {
      this.removeEventListener(event, this[listener]);
    });

    this.layers.forEach((layer) => {
      layer.disposeEventListeners();
    });
  }
};