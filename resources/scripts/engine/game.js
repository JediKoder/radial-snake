Engine.Game = class Game {
  get fps() {
    return 60;
  }

  get speed() {
    return 1;
  }

  constructor(canvas, debugging) {
    this.canvas = canvas;
    this.debugging = debugging;
    this.lastUpdate = this.creation = new Date().getTime();

    canvas.width = 1280;
    canvas.height = 720;
    canvas.focus();

    canvas.addEventListener("mousedown", canvas.focus, false);
    canvas.addEventListener("keydown", onKeyDown.bind(this), false);
    canvas.addEventListener("keyup", onKeyUp.bind(this), false);

    this.assets = {};
    this.events = new Map();
    this.context = canvas.getContext("2d");
    this.bufferedCanvas = document.createElement("canvas");
    this.bufferedContext = this.bufferedCanvas.getContext("2d");
    this.bufferedCanvas.width = canvas.width;
    this.bufferedCanvas.height = canvas.height;
    this.keyStates = new Engine.KeyStates;
  }

  draw() {
    if (this.debugging) {
      this.context.restore();
      this.context.fillStyle = "black";
      this.context.save();
      this.context.beginPath();
      this.context.rect(0, 0, this.canvas.width, this.canvas.height);
      this.context.fill();
      this.drawScreen(this.context);
    } else {
      this.bufferedContext.restore();
      this.bufferedContext.fillStyle = "black";
      this.bufferedContext.save();
      this.bufferedContext.beginPath();
      this.bufferedContext.rect(0, 0, this.canvas.width, this.canvas.height);
      this.bufferedContext.fill();
      this.drawScreen(this.bufferedContext);
      this.context.drawImage(this.bufferedCanvas, 0, 0);
    }
  }

  drawScreen(context) {
    if (this.screen.loading) return;
    if (this.screen.draw) this.screen.draw(context);
  }

  update() {
    let { lastUpdate } = this;
    let currUpdate = this.lastUpdate = new Date().getTime();
    let span = currUpdate - lastUpdate;
    this.updateScreen(span / this.speed);
  }

  updateScreen(span) {
    this.screen.age += span;
    if (this.screen.loading) return;
    if (this.screen.update) this.screen.update(span);
  }

  loop() {
    if (!this.playing) return;

    setTimeout(() => {
      this.draw();
      this.update();
      this.loop();
    }, this.fps);
  }

  play() {
    this.playing = true;
    this.loop();
  }

  pause() {
    this.playing = false;
  }

  changeScreen(Screen, ...screenArgs) {
    if (this.screen) {
      this.unloadScreen();
      this.screen.disposeEventListeners();
    }

    this.screen = new Screen(this, ...screenArgs);

    this.loadScreen(() => {
      this.screen.initEventListeners();
      this.screen.initialize();
    });
  }

  loadScreen(callback = _.noop) {
    if (!this.screen.load) return callback();

    this.screen.loading = true;
    let loadsize = 0;

    let onload = _.after(loadsize, () => {
      delete this.screen.loading;
      return callback();
    });

    _.extend(this.screen.assets, this.screen.load(new Engine.AssetsLoader(() => {
      loadsize++;
      return onload;
    })));
  }

  unloadScreen() {
    _.omit(this.assets, this.screen.unload && this.screen.unload());
  }

  extendAssets(assets) {
    _.extend(this.assets, assets);
  }

  clearAssets() {
    this.assets = {};
  }

  addEventListener(type, listener, target) {
    let boundListener = listener.bind(target);
    this.events.set(listener, boundListener);
    this.canvas.addEventListener(type, boundListener, false);
  }

  removeEventListener(type, listener) {
    let boundListener = this.events.get(listener);
    this.events.delete(listener);
    this.canvas.removeEventListener(type, boundListener, false);
  }
};

function onKeyDown(e) {
  e.preventDefault();
  this.keyStates.add(e.keyCode);
}

function onKeyUp(e) {
  e.preventDefault();
  this.keyStates.remove(e.keyCode);
}