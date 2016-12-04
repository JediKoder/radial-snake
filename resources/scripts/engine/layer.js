Engine.Layer = class Layer {
  get width() {
    return this.screen.width;
  }

  get height() {
    return this.screen.height;
  }

  constructor(screen) {
    this.screen = screen;
    this.age = 0;
    this.creation = new Date().getTime();
    ({ assets: this.assets, keyStates: this.keyStates } = screen);
  }

  initEventListeners() {
    if (!this.events) return;

    this.events.forEach((event, listener) => {
      this.screen.addEventListener(event, this[listener], this);
    });
  }

  disposeEventListeners() {
    if (!this.events) return;

    this.events.forEach((event, listener) => {
      this.screen.removeEventListener(event, this[listener]);
    });
  }
};