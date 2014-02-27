###
  Hexagon calculations and objects, taken and modified from

  https://github.com/mpalmerlee/HexagonTools

###
angular.module('hextools', ['autoworms.services']).service 'hexService', (logger) ->

  log = logger('hexService')

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
    # log.debug "Values for Hex: \nSide Length, z: " + z + "\nx:" + x + "\ny: " +
    #   y + "\nWidth:" + width + "\nHeight: " + height
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
  }