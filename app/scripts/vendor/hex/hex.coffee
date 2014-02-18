###
  Hexagon calculations and objects, taken and modified from

  https://github.com/mpalmerlee/HexagonTools

###
angular.module('hextools', ['utils.logger']).service 'hexService', (logger) ->

  log = logger('hextools');

  # ------------------------
  # Hex calculations
  # ------------------------

  ###
  Calculates a HexConfig for use in building the grid
  @param z {Double}
  @param r {Double}
  @returns {HexConfig}
  ###
  findHexWithSideLengthZAndRatio = (z, r)->
    #solve quadratic
    r2 = Math.pow(r, 2)
    a = (1 + r2) / r2
    b = z / r2
    c = ((1 - 4.0 * r2) / (4.0 * r2)) * (Math.pow(z, 2))
    x = (-b + Math.sqrt(Math.pow(b, 2) - (4.0 * a * c))) / (2.0 * a)
    y = ((2.0 * x) + z) / (2.0 * r)
    width = ((2.0 * x) + z)
    height = (2.0 * y)
    # log.debug "Values for Hex: \nSide Length, z: " + z + "\nx:" + x + "\ny: " + y + "\nWidth:" + width + "\nHeight: " + height
    new HexConfig(width, height, z)


  ###
  Calculates a HexConfig for use in building the grid
  @param width {Double}
  @param height {Double}
  @returns {HexConfig}
  ###
  findHexWithWidthAndHeight = (width, height) ->
    y = height / 2.0

    #solve quadratic
    a = -3.0
    b = (-2.0 * width)
    c = (Math.pow(width, 2)) + (Math.pow(height, 2))
    z = (-b - Math.sqrt(Math.pow(b, 2) - (4.0 * a * c))) / (2.0 * a)
    x = (width - z) / 2.0
    # log.debug "Values for Hex: \nWidth: " + width + "\nHeight: " + height + "\nSide Length, z: " + z + "\nx: " + x + "\ny:" + y
    new HexConfig(width, height, z)


  ###
  Draw a hex grid using the specified canvas and configuration
  @param canvas {Html Canvas}
  @param hexConfig {HexConfig}
  @returns {Grid}
  ###
  drawHexGrid = (canvas, hexConfig) ->
    grid = new Grid(800, 600, hexConfig)
    ctx = canvas.getContext("2d")
    ctx.clearRect 0, 0, 800, 600
    ctx.fillStyle = 'black'
    ctx.fillRect 0, 0, 800, 600
    for h of grid.locations
      grid.locations[h].draw ctx
    grid


  getHexGridZR = (z, r, canvas) ->
    config = findHexWithSideLengthZAndRatio(z, r)
    drawHexGrid(canvas, config)


  getHexGridWH = (width, height, canvas) ->
    config = findHexWithWidthAndHeight(width, height)
    drawHexGrid(canvas, config)


  getHexId = (row, col, config) ->
    letterIndex = row
    letters = ""
    while letterIndex > 25
      letters = @config.letters[letterIndex % 26] + letters
      letterIndex -= 26
    config.letters[letterIndex] + letters + (col + 1)


  changeOrientation = (canvas, config) ->
    config.toggleOrientation()
    drawHexGrid(canvas, config)


  debugHexZR = (z, r, canvas) ->
    config = findHexWithSideLengthZAndRatio(z, r)
    addHexToCanvasAndDraw 20, 20, canvas, config


  debugHexWH = (width, height, canvas) ->
    config = findHexWithWidthAndHeight()
    addHexToCanvasAndDraw 20, 20, canvas, config


  addHexToCanvasAndDraw = (x, y, canvas, config) ->
    config.drawStats = true
    hex = new Hexagon(null, x, y, config)
    ctx = canvas.getContext("2d")
    ctx.clearRect 0, 0, 800, 600
    hex.draw ctx, config


  # ------------------------
  # Objects
  # ------------------------

  ###
  A Point is simply x and y coordinates
  @constructor
  ###
  class Point
    constructor: (@x, @y) ->

  ###
  A Rectangle is x and y origin and width and height
  @constructor
  ###
  class Rectangle
    constructor: (@x, @y, @width, @height) ->

  ###
  A Line is x and y start and x and y end
  @constructor
  ###
  class Line
    constructor: (@x1, @y1, @x2, @y2) ->

  ###
  A Hexagon is a 6 sided polygon, our hexes don't have to be symmetrical, i.e. ratio of width to height could be 4 to 3
  @constructor
  ###
  class Hexagon
    constructor: (@row, @col, @x, @y, @config) ->
      @id = getHexId(@row, @col, @config)
      @points = [] #Polygon Base
      x1 = null
      y1 = null
      if config.normalOrientation
        x1 = (config.width - config.side) / 2
        y1 = (config.height / 2)
        @points.push new Point(x1 + x, y)
        @points.push new Point(x1 + config.side + x, y)
        @points.push new Point(config.width + x, y1 + y)
        @points.push new Point(x1 + config.side + x, config.height + y)
        @points.push new Point(x1 + x, config.height + y)
        @points.push new Point(x, y1 + y)
      else
        x1 = (config.width / 2)
        y1 = (config.height - config.side) / 2
        @points.push new Point(x1 + x, y)
        @points.push new Point(config.width + x, y1 + y)
        @points.push new Point(config.width + x, y1 + config.side + y)
        @points.push new Point(x1 + x, config.height + y)
        @points.push new Point(x, y1 + config.side + y)
        @points.push new Point(x, y1 + y)
      @x1 = x1
      @y1 = y1
      @topLeftPoint = new Point(@x, @y)
      @bottomRightPoint = new Point(@x + config.width, @y + config.height)
      @midPoint = new Point(@x + (config.width / 2), @y + (config.height / 2))
      @p1 = new Point(x + x1, y + y1)
      @selected = false

    ###
    draws this Hexagon to the canvas
    @this {Hexagon}
    ###
    draw: (ctx, color = null, extraText=null) ->
      selectedColor = color or "lightblue"
      color = color or "grey"
      # log.debug('drawing ' + @id)
      unless @selected
        ctx.strokeStyle = selectedColor
      else
        ctx.strokeStyle = color

      if @config.centerPoint
        # log.debug('Center drawing')
        ctx.fillStyle = color
        ctx.beginPath()
        ctx.moveTo @midPoint.x + 2, @midPoint.y
        ctx.arc(@midPoint.x, @midPoint.y, 2, 0, 2 * Math.PI, false)
        ctx.closePath()
        ctx.stroke()
      else
        ctx.lineWidth = 1
        ctx.beginPath()
        # log.debug @points
        ctx.moveTo @points[0].x, @points[0].y
        i = 1

        while i < @points.length
          p = @points[i]
          ctx.lineTo p.x, p.y
          i++
        ctx.closePath()
        ctx.stroke()

        if @id
          #draw text for debugging
          ctx.fillStyle = color
          ctx.font = "bolder 8pt Trebuchet MS,Tahoma,Verdana,Arial,sans-serif"
          ctx.textAlign = "center"
          ctx.textBaseline = "middle"

          #var textWidth = ctx.measureText(this.Planet.BoundingHex.Id);
          ctx.fillText @id, @midPoint.x, @midPoint.y

          if extraText
            ctx.fillStyle = color
            ctx.font = "bolder 8pt Trebuchet MS,Tahoma,Verdana,Arial,sans-serif"
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"

            ctx.fillText extraText, @midPoint.x, @midPoint.y - 10

        # show it on the line above
        if @pathCoordX isnt null and @pathCoordY isnt null and typeof (@pathCoordX) isnt "undefined" and typeof (@pathCoordY) isnt "undefined"

          #draw co-ordinates for debugging
          ctx.fillStyle = color
          ctx.font = "bolder 8pt Trebuchet MS,Tahoma,Verdana,Arial,sans-serif"
          ctx.textAlign = "center"
          ctx.textBaseline = "middle"

          #var textWidth = ctx.measureText(this.Planet.BoundingHex.Id);
          ctx.fillText "(" + @pathCoordX + "," + @pathCoordY + ")", @midPoint.x, @midPoint.y + 10
        if @config.drawStats
          ctx.strokeStyle = color
          ctx.lineWidth = 2

          #draw our x1, y1, and z
          ctx.beginPath()
          ctx.moveTo @p1.x, @y
          ctx.lineTo @p1.x, @p1.y
          ctx.lineTo @x, @p1.y
          ctx.closePath()
          ctx.stroke()
          ctx.fillStyle = color
          ctx.font = "bolder 8pt Trebuchet MS,Tahoma,Verdana,Arial,sans-serif"
          ctx.textAlign = "left"
          ctx.textBaseline = "middle"

          #var textWidth = ctx.measureText(this.Planet.BoundingHex.Id);
          ctx.fillText "z", @x + @x1 / 2 - 8, @y + @y1 / 2
          ctx.fillText "x", @x + @x1 / 2, @p1.y + 10
          ctx.fillText "y", @p1.x + 2, @y + @y1 / 2
          ctx.fillText "z = " + config.side, @p1.x, @p1.y + @y1 + 10
          ctx.fillText "(" + @x1.toFixed(2) + "," + @y1.toFixed(2) + ")", @p1.x, @p1.y + 10
      return

    ###
    Finds the six adjacent neighbors of this hex.
    @returns {Array} Points of above, above-right, below-right, below, below-left, above-left hexes
    ###
    getNeighbors: -> [
      new Point(@pathCoordX, @pathCoordY-1)
      new Point(@pathCoordX+1, @pathCoordY)
      new Point(@pathCoordX+1, @pathCoordY+1)
      new Point(@pathCoordX, @pathCoordY+1)
      new Point(@pathCoordX-1, @pathCoordY)
      new Point(@pathCoordX-1, @pathCoordY-1)
    ]


    ###
    Returns true if the x,y coordinates are inside this hexagon
    @this {Hexagon}
    @return {boolean}
    ###
    isInBounds: (x, y) ->
      @contains new Point(x, y)

    ###
    Returns true if the point is inside this hexagon, it is a quick contains
    @this {Hexagon}
    @param {Point} p the test point
    @return {boolean}
    ###
    isInHexBounds: (p) -> #Point
      return true if @topLeftPoint.x < p.x and @topLeftPoint.y < p.y and p.x < @bottomRightPoint.x and p.y < @bottomRightPoint.y
      false


    #grabbed from:
    #http://www.developingfor.net/c-20/testing-to-see-if-a-point-is-within-a-polygon.html
    #and
    #http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html#The%20C%20Code
    ###
    Returns true if the point is inside this hexagon, it first uses the quick isInHexBounds contains, then check the boundaries
    @this {Hexagon}
    @param {Point} p the test point
    @return {boolean}
    ###
    contains: (p) -> #Point
      isIn = false
      if @isInHexBounds(p)

        #turn our absolute point into a relative point for comparing with the polygon's points
        #var pRel = new Point(p.x - this.x, p.y - this.y);
        i = undefined
        j = 0
        i = 0
        j = @points.length - 1

        while i < @points.length
          iP = @points[i]
          jP = @points[j]

          #((iP.y > p.y) != (jP.y > p.y))
          isIn = not isIn  if (((iP.y <= p.y) and (p.y < jP.y)) or ((jP.y <= p.y) and (p.y < iP.y))) and (p.x < (jP.x - iP.x) * (p.y - iP.y) / (jP.y - iP.y) + iP.x)
          j = i++
      isIn

  # --------------------------------
  # Grid stuff
  # --------------------------------

  ###
  A Grid is the model of the playfield containing hexes.
  @constructor
  ###
  class Grid
    ###
    @width: {double}
    @height: {double}
    ###
    constructor: (width, height, @config) ->
      @locations = []
      @rowMax = 0
      @colMax = 0

      #setup a dictionary for use later for assigning the X or Y Coord (depending on Orientation)
      HexagonsByXOrYCoord = {} #Dictionary<int, List<Hexagon>>
      row = 0
      y = 0.0
      while y + @config.height <= height
        col = 0
        offset = 0.0
        if row % 2 is 1
          if @config.normalOrientation
            offset = (@config.width - @config.side) / 2 + @config.side
          else
            offset = @config.width / 2
          col = 1
        x = offset
        while x + @config.width <= width
          h = new Hexagon(row, col, x, y, @config)
          if row > @rowMax
            @rowMax = row
          if row == 0 and col > @colMax
            @colMax = col

          pathCoord = col
          if @config.normalOrientation
            h.pathCoordX = col #the column is the x coordinate of the hex, for the y coordinate we need to get more fancy
          else
            h.pathCoordY = row
            pathCoord = row
          @locations.push h
          HexagonsByXOrYCoord[pathCoord] = []  unless HexagonsByXOrYCoord[pathCoord]
          HexagonsByXOrYCoord[pathCoord].push h
          col += 2
          if @config.normalOrientation
            x += @config.width + @config.side
          else
            x += @config.width
        row++
        if @config.normalOrientation
          y += @config.height / 2
        else
          y += (@config.height - @config.side) / 2 + @config.side

      #finally go through our list of hexagons by their x co-ordinate to assign the y co-ordinate
      for coord1 of HexagonsByXOrYCoord
        hexagonsByXOrY = HexagonsByXOrYCoord[coord1]
        coord2 = Math.floor(coord1 / 2) + (coord1 % 2)
        for i of hexagonsByXOrY
          h = hexagonsByXOrY[i] #Hexagon
          if @config.normalOrientation
            h.pathCoordY = coord2++
          else
            h.pathCoordX = coord2++

      @rowMax++
      log.debug('Max: (' + @rowMax + ', ' + @colMax + ')')


    drawLineBetween: (ctx, locA, locB, color='black', width=2) ->
      log.debug('hex ', locA.id, ' drawing to ', locB.id, ' with color=', color)
      mid = locA.midPoint
      ctx.beginPath()
      ctx.strokeStyle = color
      ctx.lineWidth = width
      ctx.moveTo(mid.x, mid.y)
      mid = locB.midPoint
      ctx.lineTo(mid.x, mid.y)
      ctx.stroke()
      ctx.closePath()
      locA.draw(ctx)
      locB.draw(ctx)


    ###
    Returns a hex at a given point
    @this {Grid}
    @return {Hexagon}
    ###
    getHexAt: (p) -> #Point

      #find the hex that contains this point
      for h of @locations
        return @locations[h]  if @locations[h].contains(p)
      null


    ###
    Returns a distance between two hexes
    @this {Grid}
    @property h1 {Hexagon}
    @property h2 {Hexagon}
    @return {number}
    ###
    getHexDistance: (h1, h2) ->
      #a good explanation of this calc can be found here:
      #http://playtechs.blogspot.com/2007/04/hex-grids.html
      deltaX = h1.pathCoordX - h2.pathCoordX
      deltaY = h1.pathCoordY - h2.pathCoordY
      (Math.abs(deltaX) + Math.abs(deltaY) + Math.abs(deltaX - deltaY)) / 2


    ###
    Gets a hex by its ID
    @this {Grid}
    @return {Hexagon}
    ###
    getHexById: (id) ->
      for i of @locations
        return @locations[i] if @locations[i].id is id
      null

    getHexByPoint: (point) ->
      point = @resolveCoord(point)
      #log.debug('looking for ' + point.x + ',' + point.y)

      for hex in @locations
        return hex if hex.pathCoordX == point.x and hex.pathCoordY == point.y

      log.debug('could not find it')

    ###
    Turn a list of hex points into a list of hexes
    @param points {Array} a list points
    @return {Array} of Hexes
    ###
    getLocations: (points) ->
      hexes = []

      for point in points
        #log.debug('getting hex for ' + point.x + ',' + point.y)
        hexes.push(@getHexByPoint(point))

      return hexes

    resolveCoord: (point) ->
      x = point.x
      y = point.y

      while x < 0
        x = @rowMax + x + 1

      while x > @rowMax
        x -= @rowMax

      bounds = @colLimits(x)

      while y < bounds[0]
        y = y + bounds[1] - bounds[0] + 1

      while y > bounds[1]
        y = y - bounds[1] + bounds[0]

      return new Point(x, y)

    ###
    Calculates the lower and upper limits of column indices for a given row
    @param x {Integer} row
    @returns {Array} [lower, upper]
    ###
    colLimits: (x) ->
      [Math.ceil(x/2), (@colMax-Math.floor((@rowMax-x)/2))]


  ###
  Simple configuration object
  ###
  class HexConfig
    constructor: (
      @width = 91.14378277661477,
      @height = 91.14378277661477,
      @side = 50.0,
      @normalOrientation = true,
      @centerPoint = true,
      @drawStats = false,
      @letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ") ->

    toggleOrientation: ->
      @orientation = !@orientation

  labels = [
    'N'
    'NE'
    'SE'
    'S'
    'SW'
    'NW'
  ]

  labelToIndex = (direction) ->
    ix = labels.indexOf(direction);
    if typeof ix == 'undefined'
      throw new Error('bad direction: ' + direction)
    ix

  resolveLabelIndex = (ix) ->
    while ix<0
      ix += labels.length

    ix % labels.length

  indexToLabel = (ix) ->
    ix = resolveLabelIndex(ix)
    while ix<0
      ix += labels.length

    labels[ix % labels.length]

  return {
    Grid: Grid,
    Hexagon: Hexagon,
    Point: Point,
    debugHexZR: debugHexZR
    debugHexWH: debugHexWH
    changeOrientation: changeOrientation
    getHexGridZR: getHexGridZR
    getHexGridWH: getHexGridWH
    labels: labels
    labelToIndex: labelToIndex
    indexToLabel: indexToLabel
    resolveLabelIndex: resolveLabelIndex
  }