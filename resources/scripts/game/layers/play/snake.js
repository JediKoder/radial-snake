Game.Layers.Play.Snake = class Snake extends Engine.Layer {
  constructor(screen) {
    super(screen);

    this.snakes = [
      new Game.Entities.Snake(
        this.width / 4,
        this.height / 4,
        50,
        Math.PI / 4,
        100,
        "FireBrick",
        this.keyStates,
        {
          keys: {
            left: 37, // left
            right: 39 // right
        }
      }),

      new Game.Entities.Snake(
        (this.width / 4) * 3,
        (this.height / 4) * 3,
        50,
        (-Math.PI / 4) * 3,
        100,
        "DodgerBlue",
        this.keyStates,
        {
          keys: {
            left: 65, // a
            right: 68 // d
        }
      })
    ];

    screen.appendLayer(Game.Layers.Play.Score, this.snakes);
  }

  draw(context) {
    this.snakes.forEach(snake => snake.draw(context));
  }

  update(span) {
    let disqualifiedIndexes = [];

    this.snakes.forEach((snake, i) => {
      snake.update(span);
      let selfIntersection = snake.getSelfIntersection();
      if (selfIntersection != null) disqualifiedIndexes.push(i);

      this.snakes.forEach((rival, j) => {
        if (i == j) return;
        let snakeIntersection = snake.getSnakeIntersection(rival);
        if (snakeIntersection != null) disqualifiedIndexes.push(i);
      });
    });

    disqualifiedIndexes.forEach(index => {
      this.snakes.splice(index, 1);
      if (this.snakes.length == 1) {
        this.snakes[0].score++;
      }
    });
  }
};