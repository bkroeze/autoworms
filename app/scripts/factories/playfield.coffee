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
      @neighbors = null
      @id = @hex.id

    getNeighbors: ->
      @neighbors = @playField.getNeighbors(this) if not @neighbors
      @neighbors

    setIncoming: (direction, state=true) ->
      ix = (hex.labelToIndex(direction)+3) % 6
      log.debug('hex ', @id, ' incoming ', hex.labels[ix])
      @used[ix] = state

    ###
    Mark a direction as "used", and also mark the neighbor hex as used in the correct position
    @param direction {string} the direction label (i.e. N)
    @param state {boolean} [optional] true to mark the direction "used"
    @return {boolean} true if the direction state changed
    ###
    use: (direction, state=true) ->
      ix = hex.labelToIndex(direction)
      if @used[ix] == state
        return false
      @used[ix] = state
      log.debug('hex ', @id, ' use ', direction)

      neighbors = @getNeighbors()
      neighbors[ix].setIncoming direction, state
      @playField.markDirty(this.hex.id)
      true

    draw: (ctx) ->
      neighbors = @playField.getNeighbors(this)
      for direction, i in @used when direction is true
        log.debug('hex ', @id, ' drawing ', hex.labels[i])
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
      @dirty = {}
      @hexes = {}
      for hex in @grid.hexes
        @hexes[hex.id] = new WormHex(this, hex)

    draw: (canvas) ->
      log.debug 'draw'
      ctx = canvas.getContext '2d'
      for key, state of @dirty when state is true
        log.debug('drawing dirty ', key);
        @hexes[key].draw ctx
      @dirty = {}

    getNeighbors: (wormhex) ->
      points = wormhex.hex.getNeighbors()
      hexes = @grid.getHexes(points)
      return (@hexes[hex.id] for hex in hexes)

    markDirty: (hexId) ->
      @dirty[hexId] = true


