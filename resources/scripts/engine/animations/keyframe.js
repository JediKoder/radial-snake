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
      "x", "y", "width", "height", "opacity"
    ];

    this.trimmedKeyframes = this.animables.reduce((trimmedKeyframes, key) => {
      trimmedKeyframes[key] = keyframes.filter(keyframe => keyframe[key] != null);
      return trimmedKeyframes;
    }, {});

    _.each(keyframes[0], (value, key) => {
      if (this.animables.includes(key)) sprite[key] = value;
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
        this.frame += span;

        if (this.frame > this.lastFrame) {
          this.frame = this.lastFrame;
          this.playing = false;
        }

        break;

      case "cyclic":
        this.frame = this.age % this.lastFrame;
        break;

      case "full":
        this.frame = this.age % this.lastFrame;
        let animationComplete = (this.age / this.lastFrame) % 2 >= 1;
        if (animationComplete) this.frame = this.lastFrame - this.frame;
        break;
    }

    this.animables.forEach(key => {
      let motion = this.getKeyframeMotion(key);

      if (motion)
        this.sprite[key] = this.calculateRelativeValue(motion, key);
    });
  }

  play() {
    this.playing = true;
  }

  pause() {
    this.playing = false;
  }

  getKeyframeMotion(key) {
    let keyframes = this.trimmedKeyframes[key];

    if (keyframes == null) return;
    if (keyframes.length < 2) return;
    if (this.frame > _.last(keyframes).frame) return;

    let start = this.findStartKeyframe(keyframes);
    let end = this.findEndKeyframe(keyframes);
    let ratio = this.getKeyframesRatio(start, end);

    return { start, end, ratio };
  }

  getKeyframesRatio(start, end) {
    return (this.frame - start.frame) / (end.frame - start.frame);
  }

  findEndKeyframe(keyframes) {
    return _.find(keyframes, keyframe =>
      keyframe.frame >= (this.frame || 1)
    );
  }

  findStartKeyframe(keyframes) {
    let resultIndex;

    keyframes.some((keyframe, currIndex) => {
      if (keyframe.frame >= (this.frame || 1)) {
        resultIndex = currIndex;
        return true;
      }
    });

    return keyframes[resultIndex - 1];
  }

  calculateRelativeValue(motion, key) {
    let a = motion.start[key];
    let b = motion.end[key];
    let r = motion.ratio;
    let easing = r > 0 ? motion.start.easing : motion.end.easing;

    switch (easing) {
      case "in": r = Math.sin((r * Math.PI) / 2); break;
      case "out": r = Math.cos((r * Math.PI) / 2); break;
    }

    return ((b - a) * r) + a;
  }
};