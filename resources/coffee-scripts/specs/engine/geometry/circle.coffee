describe "Engine.Geometry.Circle class", ->
  beforeEach ->
    @circle = new Engine.Geometry.Circle 1, 1, 5, [0, 1.5 * Math.PI]

  describe "getX method", ->
    describe "given inranged rad", ->
      it "returns x", ->
        expect(@circle.getX(0 * Math.PI)).toBeCloseTo 6
        expect(@circle.getX(0.5 * Math.PI)).toBeCloseTo 1
        expect(@circle.getX(1 * Math.PI)).toBeCloseTo -4
        expect(@circle.getX(1.5 * Math.PI)).toBeCloseTo 1

    describe "given outranged rad", ->
      it "returns nothing", ->
        expect(@circle.getX(2 * Math.PI)).toBeUndefined()

  describe "getY method", ->
    describe "given inranged rad", ->
      it "returns y", ->
        expect(@circle.getY(0 * Math.PI)).toBeCloseTo 1
        expect(@circle.getY(0.5 * Math.PI)).toBeCloseTo 6
        expect(@circle.getY(1 * Math.PI)).toBeCloseTo 1
        expect(@circle.getY(1.5 * Math.PI)).toBeCloseTo -4

    describe "given outranged rad", ->
      it "returns nothing", ->
        expect(@circle.getY(2 * Math.PI)).toBeUndefined()

  describe "getRad method", ->
    describe "given inranged point", ->
      it "returns rad", ->
        # 0.8 PI
        point = x: -3.0450849718747346, y: 3.9389262614623686
        expect(@circle.getRad(point)).toBeCloseTo 0.8 * Math.PI

    describe "given outranged point", ->
      it "returns nothing", ->
        # 1.8 PI
        point = x: 5.045084971874736, y: -1.9389262614623664
        expect(@circle.getRad(point)).toBeUndefined()

  describe "getCircleIntersection method", ->
    describe "given circle with 2 intersection points", ->
      it "returns array with intersection points", ->
        circle = new Engine.Geometry.Circle -5, 1, 5, [0, 2 * Math.PI]
        expect(@circle.getCircleIntersection(circle)).toEqual [
          { x: -2, y: -3 }
          { x: -2, y: 5 }
        ]

    describe "given circle with 1 intersection points", ->
      it "returns array with intersection point", ->
        circle = new Engine.Geometry.Circle -5, 1, 5, [0, 1 * Math.PI]
        expect(@circle.getCircleIntersection(circle)).toEqual [
          { x: -2, y: 5 }
        ]

    describe "given kissing circle", ->
      it "returns array with intersection point", ->
        circle = new Engine.Geometry.Circle -9, 1, 5, [0, 2 * Math.PI]
        expect(@circle.getCircleIntersection(circle)).toEqual [
          { x: -4, y: 1 }
        ]

    describe "given outer circle", ->
      it "returns nothing", ->
        circle = new Engine.Geometry.Circle 10, 10, 2, [0, 2 * Math.PI]
        expect(@circle.getCircleIntersection(circle)).toBeUndefined()

    describe "given inner circle", ->
      it "return nothing", ->
        circle = new Engine.Geometry.Circle 1, 1, 2, [0, 2 * Math.PI]
        expect(@circle.getCircleIntersection(circle)).toBeUndefined()