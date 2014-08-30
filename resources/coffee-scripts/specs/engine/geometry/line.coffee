describe "Engine.Geometry.Line class", ->
  beforeEach ->
    @line = new Engine.Geometry.Line(
      { x: -5, y: -5 }
      { x: 5, y: 5 }
    )

  describe "getX method", ->
    describe "given inranged y", ->
      it "returns x", ->
        expect(@line.getX(1)).toBeCloseTo 1

    describe "given outranged y", ->
      it "returns nothing", ->
        expect(@line.getX(10)).toBeUndefined()

  describe "getY method", ->
    describe "given inranged x", ->
      it "returns y", ->
        expect(@line.getY(1)).toBeCloseTo 1

    describe "given outranged x", ->
      it "returns nothing", ->
        expect(@line.getY(10)).toBeUndefined()

  describe "hasPoint method", ->
    describe "given contained point", ->
      it "returns true", ->
        point = x: 1, y: 1
        expect(@line.hasPoint(point)).toBeTruthy()

    describe "given uncontained point", ->
      it "returns false", ->
        point = x: 10, y: 10
        expect(@line.hasPoint(point)).toBeFalsy()

  describe "getLineIntersection method", ->
    describe "given intersecting line", ->
      it "returns intersection point", ->
        line = new Engine.Geometry.Line(
          { x: 1, y: -5 }
          { x: 1, y: 5 }
        )
        expect(@line.getLineIntersection(line)).toEqual x: 1, y: 1

    describe "given parallal line", ->
      it "returns nothing", ->
        line = new Engine.Geometry.Line(
          { x: -5, y: -6 }
          { x: 5, y: 4 }
        )
        expect(@line.getLineIntersection(line)).toBeUndefined()

    describe "given outlimits line", ->
      it "returns nothing", ->
        line = new Engine.Geometry.Line(
          { x: 10, y: 10 }
          { x: 10, y: 15 }
        )
        expect(@line.getLineIntersection(line)).toBeUndefined()

  describe "getCircleIntersection method", ->
    describe "given circle with 2 intersection points", ->
      it "returns array with intersection points", ->
        circle = new Engine.Geometry.Circle 0, 0, Math.sqrt(8), [0, 2 * Math.PI]
        expect(@line.getCircleIntersection(circle)).toEqual [
          { x: 2, y: 2 }
          { x: -2, y: -2 }
        ]

    describe "given circle with 1 intersection point", ->
      it "returns array with intersection point", ->
        circle = new Engine.Geometry.Circle 0, 0, Math.sqrt(8), [0, Math.PI]
        expect(@line.getCircleIntersection(circle)).toEqual [
          { x: 2, y: 2 }
        ]

    describe "given kissing circle", ->
      it "returns array with intersection point", ->
        circle = new Engine.Geometry.Circle 2, -2, Math.sqrt(8), [0, 2 * Math.PI]
        expect(@line.getCircleIntersection(circle)).toEqual [
          { x: 0, y: 0 }
        ]

    describe "given outranged circle", ->
      it "returns nothing", ->
        circle = new Engine.Geometry.Circle 10, -10, 3, [0, 2 * Math.PI]
        expect(@line.getCircleIntersection(circle)).toBeUndefined()
