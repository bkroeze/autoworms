# --------------------------------
# Grid stuff
# --------------------------------

Grid = require('../classes/Grid')
Hexagon = require('./Hexagon')
Point = require('../classes/Point')

class HexGrid extends Grid
  ###
  A HexGrid is the model of the playfield containing hexes.
  ###

  constructor: (width, height, config) ->
    ###
    @constructor
    @width: {double}
    @height: {double}
    ###
    super 'Hex', width, height, config, [
      'N'
      'NE'
      'SE'
      'S'
      'SW'
      'NW'
    ]

    @rowMax = 0
    @colMax = 0

    #setup a dictionary for use later for assigning the X or Y Coord (depending on Orientation)
    HexagonsByXOrYCoord = {}
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
        @add h
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
    #log.debug('Max: (' + @rowMax + ', ' + @colMax + ')')


  drawLineBetween: (ctx, locA, locB, color='black', width=2) ->
    #log.debug('hex ', locA.id, ' drawing to ', locB.id, ' with color=', color)
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


  getDistance: (h1, h2) ->
    ###
    Returns a distance between two hexes
    @this {Grid}
    @property h1 {Hexagon}
    @property h2 {Hexagon}
    @return {number}

    a good explanation of this calc can be found here:
    http://playtechs.blogspot.com/2007/04/hex-grids.html
    ###
    deltaX = h1.pathCoordX - h2.pathCoordX
    deltaY = h1.pathCoordY - h2.pathCoordY
    (Math.abs(deltaX) + Math.abs(deltaY) + Math.abs(deltaX - deltaY)) / 2


  resolve: (point) ->
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

    new Point(x, y)


  colLimits: (x) ->
    ###
    Calculates the lower and upper limits of column indices for a given row
    @param x {Integer} row
    @returns {Array} [lower, upper]
    ###
    [Math.ceil(x/2), (@colMax-Math.floor((@rowMax-x)/2))]


module.exports = HexGrid