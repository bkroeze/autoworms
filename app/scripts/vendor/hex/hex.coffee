###
  Hexagon calculations and objects, taken and modified from

  https://github.com/mpalmerlee/HexagonTools

###
angular.module('hextools', ['utils.logger']).service 'hex', (logger) ->

  log = logger('hextools');
  log.debug('hextools!')
  # ------------------------
  # Hex calculations
  # ------------------------

  findHexWithSideLengthZAndRatio = ->
    z = parseFloat(document.getElementById("sideLength").value)
    r = parseFloat(document.getElementById("whRatio").value)

    #solve quadratic
    r2 = Math.pow(r, 2)
    a = (1 + r2) / r2
    b = z / r2
    c = ((1 - 4.0 * r2) / (4.0 * r2)) * (Math.pow(z, 2))
    x = (-b + Math.sqrt(Math.pow(b, 2) - (4.0 * a * c))) / (2.0 * a)
    y = ((2.0 * x) + z) / (2.0 * r)
    contentDiv = document.getElementById("hexStatus")
    width = ((2.0 * x) + z)
    height = (2.0 * y)
    contentDiv.innerHTML = "Values for Hex: <br /><b>Side Length, z:</b> " + z + "<br /><b>x:</b> " + x + "<br /><b>y:</b> " + y + "<br /><b>Width:</b> " + width + "<br /><b>Height: </b>" + height
    Hexagon.Static.WIDTH = width
    Hexagon.Static.HEIGHT = height
    Hexagon.Static.SIDE = z
    return

  findHexWithWidthAndHeight = ->
    width = parseFloat(document.getElementById("hexWidth").value)
    height = parseFloat(document.getElementById("hexHeight").value)
    y = height / 2.0

    #solve quadratic
    a = -3.0
    b = (-2.0 * width)
    c = (Math.pow(width, 2)) + (Math.pow(height, 2))
    z = (-b - Math.sqrt(Math.pow(b, 2) - (4.0 * a * c))) / (2.0 * a)
    x = (width - z) / 2.0
    contentDiv = document.getElementById("hexStatus")
    contentDiv.innerHTML = "Values for Hex: <br /><b>Width:</b> " + width + "<br /><b>Height: </b>" + height + "<br /><b>Side Length, z:</b> " + z + "<br /><b>x:</b> " + x + "<br /><b>y:</b> " + y
    Hexagon.Static.WIDTH = width
    Hexagon.Static.HEIGHT = height
    Hexagon.Static.SIDE = z
    return

  drawHexGrid = ->
    grid = new Grid(800, 600)
    canvas = document.getElementById("hexCanvas")
    ctx = canvas.getContext("2d")
    ctx.clearRect 0, 0, 800, 600
    for h of grid.hexes
      grid.hexes[h].draw ctx
    return

  getHexGridZR = ->
    findHexWithSideLengthZAndRatio()
    drawHexGrid()
    return

  getHexGridWH = ->
    findHexWithWidthAndHeight()
    drawHexGrid()
    return

  changeOrientation = ->
    if document.getElementById("hexOrientationNormal").checked
      Hexagon.Static.ORIENTATION = Hexagon.Orientation.Normal
    else
      Hexagon.Static.ORIENTATION = Hexagon.Orientation.Rotated
    drawHexGrid()
    return

  debugHexZR = ->
    findHexWithSideLengthZAndRatio()
    addHexToCanvasAndDraw 20, 20
    return

  debugHexWH = ->
    findHexWithWidthAndHeight()
    addHexToCanvasAndDraw 20, 20
    return

  addHexToCanvasAndDraw = (x, y) ->
    Hexagon.Static.DRAWSTATS = true
    hex = new Hexagon(null, x, y)
    canvas = document.getElementById("hexCanvas")
    ctx = canvas.getContext("2d")
    ctx.clearRect 0, 0, 800, 600
    hex.draw ctx
    return


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
    constructor: (@id, @x, @y) ->
      @points = [] #Polygon Base
      x1 = null
      y1 = null
      if Hexagon.Static.ORIENTATION is Hexagon.Orientation.Normal
        x1 = (Hexagon.Static.WIDTH - Hexagon.Static.SIDE) / 2
        y1 = (Hexagon.Static.HEIGHT / 2)
        @points.push new Point(x1 + x, y)
        @points.push new Point(x1 + Hexagon.Static.SIDE + x, y)
        @points.push new Point(Hexagon.Static.WIDTH + x, y1 + y)
        @points.push new Point(x1 + Hexagon.Static.SIDE + x, Hexagon.Static.HEIGHT + y)
        @points.push new Point(x1 + x, Hexagon.Static.HEIGHT + y)
        @points.push new Point(x, y1 + y)
      else
        x1 = (Hexagon.Static.WIDTH / 2)
        y1 = (Hexagon.Static.HEIGHT - Hexagon.Static.SIDE) / 2
        @points.push new Point(x1 + x, y)
        @points.push new Point(Hexagon.Static.WIDTH + x, y1 + y)
        @points.push new Point(Hexagon.Static.WIDTH + x, y1 + Hexagon.Static.SIDE + y)
        @points.push new Point(x1 + x, Hexagon.Static.HEIGHT + y)
        @points.push new Point(x, y1 + Hexagon.Static.SIDE + y)
        @points.push new Point(x, y1 + y)
      @x1 = x1
      @y1 = y1
      @topLeftPoint = new Point(@x, @y)
      @bottomRightPoint = new Point(@x + Hexagon.Static.WIDTH, @y + Hexagon.Static.HEIGHT)
      @midPoint = new Point(@x + (Hexagon.Static.WIDTH / 2), @y + (Hexagon.Static.HEIGHT / 2))
      @p1 = new Point(x + x1, y + y1)
      @selected = false

    ###
    draws this Hexagon to the canvas
    @this {Hexagon}
    ###
    draw: (ctx) ->
      log.debug('drawing ' + @id)
      unless @selected
        ctx.strokeStyle = "grey"
      else
        ctx.strokeStyle = "black"
      ctx.lineWidth = 1
      ctx.beginPath()
      log.debug @points
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
        ctx.fillStyle = "black"
        ctx.font = "bolder 8pt Trebuchet MS,Tahoma,Verdana,Arial,sans-serif"
        ctx.textAlign = "center"
        ctx.textBaseline = "middle"

        #var textWidth = ctx.measureText(this.Planet.BoundingHex.Id);
        ctx.fillText @id, @midPoint.x, @midPoint.y
      if @PathCoOrdX isnt null and @PathCoOrdY isnt null and typeof (@PathCoOrdX) isnt "undefined" and typeof (@PathCoOrdY) isnt "undefined"

        #draw co-ordinates for debugging
        ctx.fillStyle = "black"
        ctx.font = "bolder 8pt Trebuchet MS,Tahoma,Verdana,Arial,sans-serif"
        ctx.textAlign = "center"
        ctx.textBaseline = "middle"

        #var textWidth = ctx.measureText(this.Planet.BoundingHex.Id);
        ctx.fillText "(" + @PathCoOrdX + "," + @PathCoOrdY + ")", @midPoint.x, @midPoint.y + 10
      if Hexagon.Static.DRAWSTATS
        ctx.strokeStyle = "black"
        ctx.lineWidth = 2

        #draw our x1, y1, and z
        ctx.beginPath()
        ctx.moveTo @p1.x, @y
        ctx.lineTo @p1.x, @p1.y
        ctx.lineTo @x, @p1.y
        ctx.closePath()
        ctx.stroke()
        ctx.fillStyle = "black"
        ctx.font = "bolder 8pt Trebuchet MS,Tahoma,Verdana,Arial,sans-serif"
        ctx.textAlign = "left"
        ctx.textBaseline = "middle"

        #var textWidth = ctx.measureText(this.Planet.BoundingHex.Id);
        ctx.fillText "z", @x + @x1 / 2 - 8, @y + @y1 / 2
        ctx.fillText "x", @x + @x1 / 2, @p1.y + 10
        ctx.fillText "y", @p1.x + 2, @y + @y1 / 2
        ctx.fillText "z = " + Hexagon.Static.SIDE, @p1.x, @p1.y + @y1 + 10
        ctx.fillText "(" + @x1.toFixed(2) + "," + @y1.toFixed(2) + ")", @p1.x, @p1.y + 10
      return


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

  Hexagon.Orientation =
    Normal: 0
    Rotated: 1

  Hexagon.Static =
    HEIGHT: 91.14378277661477
    WIDTH: 91.14378277661477
    SIDE: 50.0
    ORIENTATION: Hexagon.Orientation.Normal
    DRAWSTATS: false #hexagons will have 25 unit sides for now

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
    constructor: (width, height) ->
      @hexes = []

      #setup a dictionary for use later for assigning the X or Y CoOrd (depending on Orientation)
      HexagonsByXOrYCoOrd = {} #Dictionary<int, List<Hexagon>>
      row = 0
      y = 0.0
      while y + Hexagon.Static.HEIGHT <= height
        col = 0
        offset = 0.0
        if row % 2 is 1
          if Hexagon.Static.ORIENTATION is Hexagon.Orientation.Normal
            offset = (Hexagon.Static.WIDTH - Hexagon.Static.SIDE) / 2 + Hexagon.Static.SIDE
          else
            offset = Hexagon.Static.WIDTH / 2
          col = 1
        x = offset
        while x + Hexagon.Static.WIDTH <= width
          hexId = @getHexId(row, col)
          h = new Hexagon(hexId, x, y)
          pathCoOrd = col
          if Hexagon.Static.ORIENTATION is Hexagon.Orientation.Normal
            h.PathCoOrdX = col #the column is the x coordinate of the hex, for the y coordinate we need to get more fancy
          else
            h.PathCoOrdY = row
            pathCoOrd = row
          @hexes.push h
          HexagonsByXOrYCoOrd[pathCoOrd] = []  unless HexagonsByXOrYCoOrd[pathCoOrd]
          HexagonsByXOrYCoOrd[pathCoOrd].push h
          col += 2
          if Hexagon.Static.ORIENTATION is Hexagon.Orientation.Normal
            x += Hexagon.Static.WIDTH + Hexagon.Static.SIDE
          else
            x += Hexagon.Static.WIDTH
        row++
        if Hexagon.Static.ORIENTATION is Hexagon.Orientation.Normal
          y += Hexagon.Static.HEIGHT / 2
        else
          y += (Hexagon.Static.HEIGHT - Hexagon.Static.SIDE) / 2 + Hexagon.Static.SIDE

      #finally go through our list of hexagons by their x co-ordinate to assign the y co-ordinate
      for coOrd1 of HexagonsByXOrYCoOrd
        hexagonsByXOrY = HexagonsByXOrYCoOrd[coOrd1]
        coOrd2 = Math.floor(coOrd1 / 2) + (coOrd1 % 2)
        for i of hexagonsByXOrY
          h = hexagonsByXOrY[i] #Hexagon
          if Hexagon.Static.ORIENTATION is Hexagon.Orientation.Normal
            h.PathCoOrdY = coOrd2++
          else
            h.PathCoOrdX = coOrd2++

    getHexId: (row, col) ->
      letterIndex = row
      letters = ""
      while letterIndex > 25
        letters = Grid.Static.Letters[letterIndex % 26] + letters
        letterIndex -= 26
      Grid.Static.Letters[letterIndex] + letters + (col + 1)


    ###
    Returns a hex at a given point
    @this {Grid}
    @return {Hexagon}
    ###
    getHexAt: (p) -> #Point

      #find the hex that contains this point
      for h of @hexes
        return @hexes[h]  if @hexes[h].contains(p)
      null


    ###
    Returns a distance between two hexes
    @this {Grid}
    @return {number}
    ###
    getHexDistance: (h1, h2) -> #Hexagon
    #Hexagon

      #a good explanation of this calc can be found here:
      #http://playtechs.blogspot.com/2007/04/hex-grids.html
      deltaX = h1.PathCoOrdX - h2.PathCoOrdX
      deltaY = h1.PathCoOrdY - h2.PathCoOrdY
      (Math.abs(deltaX) + Math.abs(deltaY) + Math.abs(deltaX - deltaY)) / 2


    ###
    Gets a hex by its ID
    @this {Grid}
    @return {Hexagon}
    ###
    getHexById: (id) ->
      for i of @hexes
        return @hexes[i]  if @hexes[i].id is id
      null

  Grid.Static = Letters: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

  return {
    Grid: Grid,
    Hexagon: Hexagon,
    Point: Point,
    debugHexZR: debugHexZR
    debugHexWH: debugHexWH
    changeOrientation: changeOrientation
    getHexGridZR: getHexGridZR
    getHexGridWH: getHexGridWH
  }