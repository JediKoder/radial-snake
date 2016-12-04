window.Restoreable = class Restoreable {
  constructor(...restoreableProps) {
    this._restoreableProps = [];
    this._restoreableStates = [];
  }

  save() {
    this._restoreableStates.push(this._restoreableProps.reduce((state, prop) => {
      state[prop] = this[prop];
      return state;
    }, {}));
  }

  restore() {
    _.extend(this, this._restoreableStates.pop());
  }
};