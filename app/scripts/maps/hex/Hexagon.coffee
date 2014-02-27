Point = require('../../../../build/scripts/maps/classes/Point')

class Hexagon
  ###
  A Hexagon is a 6 sided polygon, our hexes don't have to be symmetrical, i.e. ratio of width to height could be 4 to 3
  ###

  constructor: (@row, @col, @x, @y, @config) ->
    @id = @x + ':' + @y
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


  draw: (ctx, color = null, extraText=null) ->
    ###
    draws this Hexagon to the canvas
    @this {Hexagon}
    ###
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


  getNeighbors: ->
    ###
    Finds the six adjacent neighbors of this hex.
    @returns {Array} Points of above, above-right, below-right, below, below-left, above-left hexes
    ###

    [
      new Point(@pathCoordX, @pathCoordY-1)
      new Point(@pathCoordX+1, @pathCoordY)
      new Point(@pathCoordX+1, @pathCoordY+1)
      new Point(@pathCoordX, @pathCoordY+1)
      new Point(@pathCoordX-1, @pathCoordY)
      new Point(@pathCoordX-1, @pathCoordY-1)
    ]


  isInBounds: (x, y) ->
    ###
    Returns true if the x,y coordinates are inside this hexagon
    @this {Hexagon}
    @return {boolean}
    ###
    @contains new Point(x, y)


  isInHexBounds: (p) ->
    ###
    Returns true if the point is inside this hexagon, it is a quick contains
    @this {Hexagon}
    @param {Point} p the test point
    @return {boolean}
    ###

    @topLeftPoint.x < p.x and @topLeftPoint.y < p.y and p.x < @bottomRightPoint.x and p.y < @bottomRightPoint.y


  #grabbed from:
  #http://www.developingfor.net/c-20/testing-to-see-if-a-point-is-within-a-polygon.html
  #and
  #http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html#The%20C%20Code
  contains: (p) -> #Point
    ###
    Returns true if the point is inside this hexagon, it first uses the quick isInHexBounds contains, then check the boundaries
    @this {Hexagon}
    @param {Point} p the test point
    @return {boolean}
    ###

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

module.exports = Hexagon