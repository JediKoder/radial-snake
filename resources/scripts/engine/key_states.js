Engine.KeyStates = class KeyStates {
  constructor() {
    this.states = new Array(255);
  }

  get(k) {
    return this.states[k];
  }

  add(k) {
    this.states[k] = true;
  }

  remove(k) {
    this.states[k] = false;
  }
};