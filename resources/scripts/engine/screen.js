Engine.Screen = class Screen {
  // The dimensions of the screen are correlated to dimensions of the canvas
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

  // Updates each layer, unless overrided
  update(span) {
    this.layers.forEach(layer => {
      layer.age += span;
      if (layer.update) layer.update(span);
    });
  }

  // Draws each layer, unless overrided
  draw(context) {
    this.layers.forEach(layer => layer.draw && layer.draw(context));
  }

  // Push a new layer to the top of the layers stack
  appendLayer(Layer, ...layerArgs) {
    let layer = new Layer(this, ...layerArgs);
    this.layers.push(layer);
    layer.initEventListeners();
  }

  // Push a new layer to the bottom of the layers stack
  prependLayer(Layer, ...layerArgs) {
    let layer = new Layer(this, ...layerArgs);
    this.layers.unshift(layer);
    layer.initEventListeners();
  }

  // Removes the given layer from the layers stack
  removeLayer(layer) {
    this.layers = _.without(this.layers, layer);
    layer.disposeEventListeners();
  }

  // A delegator to the game's add event listener method
  addEventListener(event, listener, target = this) {
    this.game.addEventListener(event, listener, target);
  }

  // A delegator to the game's remove event listener method
  removeEventListener(event, listener) {
    this.game.removeEventListener(event, listener);
  }

  // Initialize all specified events defined on prototype, including its layers
  initEventListeners() {
    if (!this.events) return;

    _.each(this.events, (listener, event) => {
      this.addEventListener(event, this[listener]);
    });

    this.layers.forEach(layer => {
      layer.initEventListeners();
    });
  }

  // Dispose all specified events defined on prototype, including its layers
  disposeEventListeners() {
    if (!this.events) return;

    _.each(this.events, (listener, event) => {
      this.removeEventListener(event, this[listener]);
    });

    this.layers.forEach(layer => {
      layer.disposeEventListeners();
    });
  }
};