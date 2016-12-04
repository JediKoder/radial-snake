Engine.Animations.Keyframe = class Keyframe {
  constructor(sprite, keyframes) {
    this.sprite = sprite;
    this.keyframes = keyframes;
    this.age = 0;
    this.frame = 0;
    this.repMode = "none";
    this.lastKeyframe = _.last(keyframes);
    this.lastFrame = this.lastKeyframe.frame;

    this.animables = [
      "x",
      "y",
      "width",
      "height",
      "opacity"
    ];

    this.trimmedKeyframes = this.animables.reduce((trimmedKeyframes, k) => {
      trimmedKeyframes[k] = keyframes.filter(keyframe => keyframe[k] != null);
      return trimmedKeyframes;
    }, {});

    keyframes[0].forEach((k, v) => {
      if (this.animables.includes(k)) sprite[k] = v;
    });
  }

  draw(context, offsetX, offsetY) {
    this.sprite.draw(context, offsetX, offsetY);
  }

  update(span) {
    if (!this.playing) return;
    this.age += span;

    switch (this.repMode) {
      case "none":
        if ((this.frame += span) > this.lastFrame) {
          this.frame = this.lastFrame;
          this.playing = false;
        }
        break;

      case "cyclic":
        this.frame = this.age % this.lastFrame;
        break;

      case "full":
        this.frame = this.age % this.lastFrame;
        if ((this.age / this.lastFrame) % 2 >= 1) { this.frame = this.lastFrame - this.frame; }
        break;
    }

    this.animables.forEach(k => {
      let motion = this._getKeyframesMo(k);

      if (motion)
        this.sprite[k] = this._calcRelativeVal(motion, k);
    });
  }

  play() {
    this.playing = true;
  }

  pause() {
    this.playing = false;
  }

  _getKeyframesMo(k) {
    let keyframes = this.trimmedKeyframes[k];

    if ((keyframes == null) ||
       keyframes.length < 2 ||
       this.frame > _(keyframes).last().frame) {
      return;
    }

    let start = this._findStartKeyframe(keyframes);
    let end = this._findEndKeyframe(keyframes);
    let ratio = this._getKeyframesRatio(start, end);

    return {
      start,
      end,
      ratio
    };
  }

  _getKeyframesRatio(start, end) {
    return (this.frame - start.frame) / (end.frame - start.frame);
  }

  _findEndKeyframe(keyframes) {
    return _.find(keyframes, k => {
      return k.frame >= (this.frame || 1);
    });
  }

  _findStartKeyframe(keyframes) {
    let index;

    keyframes.some((k, i) => {
      if (k.frame >= (this.frame || 1)) {
        index = i;
        return true;
      }
    });

    return keyframes[index - 1];
  }

  _calcRelativeVal(motion, k) {
    let a = motion.start[k];
    let b = motion.end[k];
    let r = motion.ratio;
    let easing = r > 0 ? motion.start.easing : motion.end.easing;

    switch (easing) {
      case "in": r = Math.sin((r * Math.PI) / 2); break;
      case "out": r = Math.cos((r * Math.PI) / 2); break;
    }

    return ((b - a) * r) + a;
  }
};