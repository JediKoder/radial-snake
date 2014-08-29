describe "Engine.Geometry.Line class", ->
  beforeEach ->
    @line = new Engine.Geometry.Line 1, 1, [
      { x: -5, y: -4 }
      { x: 5, y: 6 }
    ]

    @vLine = new Engine.Geometry.Line 1, [
      { x: 1, y: -5  }
      { x: 1, y: 5 }
    ]

    @hLine = new Engine.Geometry.Line 0, 1, [
      { x: -5, y: 1  }
      { x: 5, y: 1 }
    ]

  describe "getX method", ->
    describe "given inranged y", ->
      it "returns x", ->
        expect(@line.getX(1)).toBeCloseTo 0

      it "returns x for vLine", ->
        expect(@vLine.getX(1)).toBeCloseTo 1

      it "returns nothing for hLine", ->
        expect(@hLine.getX(1)).toBeUndefined()

    describe "given outranged y", ->
      it "returns nothing", ->
        expect(@line.getX(-5)).toBeUndefined()

  describe "getY method", ->
    describe "given inranged x", ->
      it "returns y", ->
        expect(@line.getY(0)).toBeCloseTo 1

      it "returns y for hLine", ->
        expect(@hLine.getY(0)).toBeCloseTo 1

      it "returns nothing for vLine", ->
        expect(@vLine.getY(0)).toBeUndefined()

    describe "given outranged x", ->
      it "returns nothing", ->
        expect(@line.getY(10)).toBeUndefined()

  describe "isPointInLimits method", ->
    describe "given inlimits point", ->
      it "returns true", ->
        point = x: 0, y: 0
        expect(@line.isPointInLimits(point)).toBeTruthy()

    describe "given outlimits point", ->
      it "returns false", ->
        point = x: 10, y: 10
        expect(@line.isPointInLimits(point)).toBeFalsy()

  describe "hasPoint method", ->
    describe "given contained point", ->
      it "returns true", ->
        point = x: 0, y: 1
        expect(@line.hasPoint(point)).toBeTruthy()

      it "returns true for vLine", ->
        point = x: 1, y: 1
        expect(@vLine.hasPoint(point)).toBeTruthy()

    describe "given uncontained point", ->
      it "returns false", ->
        point = x: 10, y: 10
        expect(@line.hasPoint(point)).toBeFalsy()

      it "returns false for vLine", ->
        point = x: 10, y: 10
        expect(@vLine.hasPoint(point)).toBeFalsy()

  describe "getPartial method", ->
    describe "given fully contained limits", ->
      it "returns line with given limits", ->
        limits = [
          { x: -1, y: 0 }
          { x: 1, y: 2 }
        ]
        partialLine = @line.getPartial limits
        expect(partialLine.limits).toEqual [
          { x: -1, y: 0 }
          { x: 1, y: 2 }
        ]

    describe "given partialy contained limits", ->
      it "returns line with intersecting limits", ->
        limits = [
          { x: -10, y: -9 }
          { x: 1, y: 2 }
        ]
        partialLine = @line.getPartial limits
        expect(partialLine.limits).toEqual [
          { x: 1, y: 2 }
          { x: -5, y: -4 }
        ]

    describe "given uncontained limits", ->
      it "returns nothing", ->
        limits = [
          { x: -10, y: -9 }
          { x: -9, y: -8 }
        ]
        partialLine = @line.getPartial limits
        expect(partialLine).toBeUndefined()

  describe "getLineIntersect method", ->
    describe "given line", ->
      it "returns intersection point", ->
        line = new Engine.Geometry.Line -1, 1, [
          { x: -5, y: -4 }
          { x: 5, y: 6 }
        ]
        expect(@line.getLineIntersect(line)).toEqual x: 0, y: 1

      it "returns intersection point for vLine", ->
        expect(@vLine.getLineIntersect(@line)).toEqual x: 1, y: 2

    describe "given vLine", ->
      it "returns intersection point", ->
        expect(@line.getLineIntersect(@vLine)).toEqual x: 1, y: 2

    describe "given parallal line", ->
      it "returns nothing", ->
        line = new Engine.Geometry.Line 1, 2, [
          { x: -5, y: -4 }
          { x: 5, y: 6 }
        ]
        expect(@line.getLineIntersect(line)).toBeUndefined()

      it "returns nothing for vLine", ->
        line = new Engine.Geometry.Line 2, [
          { x: 1, y: -5  }
          { x: 1, y: 5 }
        ]
        expect(@line.getLineIntersect(line)).toBeUndefined()

    describe "given partialy contained line", ->
      it "returns intersecting line", ->
        line = new Engine.Geometry.Line 1, 1, [
          { x: -3, y: -2 }
          { x: 3, y: 4 }
        ]
        expect(@line.getLineIntersect(line)).toEqual line

      it "returns intersecting line for vLine", ->
        vLine = new Engine.Geometry.Line 1, [
          { x: 1, y: -2 }
          { x: 1, y: 2 }
        ]
        expect(@vLine.getLineIntersect(vLine)).toEqual vLine

    describe "given outlimits line", ->
      it "returns nothing", ->
        line = new Engine.Geometry.Line 1, 1, [
          { x: -11, y: -10 }
          { x: -10, y: -9 }
        ]
        expect(@line.getLineIntersect(line)).toBeUndefined()
