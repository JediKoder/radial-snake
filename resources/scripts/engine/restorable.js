Restorable = class Restorable {
  constructor(...restorableProps) {
    this._restorableProps = restorableProps;
    this._restorableStates = [];
  }

  save() {
    this._restorableStates.push(this._restorableProps.reduce((state, prop) => {
      state[prop] = this[prop];
      return state;
    }, {}));
  }

  restore() {
    _.extend(this, this._restorableStates.pop());
  }
};