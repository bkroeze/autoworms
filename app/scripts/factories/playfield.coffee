angular.module('autoworms').factory 'WormHex', (logger, hex) ->
  log = logger 'WormHex'

  class WormHex
    constructor: (@playField, @hex) ->
      @used = [
        false
        false
        false
        false
        false
        false
      ]

    setIncoming: (direction, state=true) ->
      ix = (hex.labelToIndex(direction)+3) % 6
      log.debug('hex ', @hex.id, ' incoming ', hex.labels[ix])
      @used[ix] = state

    ###
    Mark a direction as "used", and also mark the neighbor hex as used in the correct position
    ###
    use: (direction, state=true) ->
      ix = hex.labelToIndex(direction)
      @used[ix] = state
      log.debug('hex ', @hex.id, ' use ', direction)

      neighbors = @playField.getNeighbors(this)
      neighbors[ix].setIncoming direction, state

    draw: (ctx) ->
      neighbors = @playField.getNeighbors(this)
      for direction, i in @used when direction is true
        log.debug('hex ', @hex.id, ' drawing ', hex.labels[i])
        neighbor = neighbors[i]
        mid = @hex.midPoint
        ctx.beginPath()
        ctx.strokeStyle = "black"
        ctx.lineWidth = 2
        ctx.moveTo(mid.x, mid.y)
        mid = neighbor.hex.midPoint
        ctx.lineTo(mid.x, mid.y)
        ctx.stroke()
        ctx.closePath()


angular.module('autoworms').factory 'Playfield', (logger, WormHex) ->
  log = logger 'Playfield'

  class Playfield
    constructor: (@grid) ->
      @hexes = {}
      for hex in @grid.hexes
        console.log('Making new Wormhex: ' + hex.id);
        @hexes[hex.id] = new WormHex(this, hex)

    draw: (canvas) ->
      log.debug 'draw'
      ctx = canvas.getContext '2d'
      for key, hex of @hexes
        hex.draw ctx

    getNeighbors: (wormhex) ->
      points = wormhex.hex.getNeighbors()
      hexes = @grid.getHexes(points)
      return (@hexes[hex.id] for hex in hexes)

