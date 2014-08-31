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
