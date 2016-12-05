Game.Screens.Play.Snake = class Snake extends Engine.Layer {
  constructor(screen, snakes = []) {
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
          score: snakes[0] && snakes[0].score,
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
          score: snakes[1] && snakes[1].score,
          keys: {
            left: 65, // a
            right: 68 // d
        }
      })
    ];

    screen.appendLayer(Game.Screens.Play.Score, this.snakes);
  }

  draw(context) {
    this.snakes.forEach(snake => snake.draw(context));
  }

  update(span) {
    let disqualifiedIndexes = [];
    let allSnakes = this.snakes.slice();

    this.snakes.forEach((snake, i) => {
      snake.update(span, this.width, this.height);
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

    if (this.snakes.length <= 1) {
      this.screen.appendLayer(Game.Screens.Play.Win, allSnakes, this.snakes[0]);
    }
  }
};