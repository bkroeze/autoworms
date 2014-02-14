angular.module('autoworms.maps').factory 'Hex', (logger, hexService) ->
  log = logger 'maps.Hex'

  class Hex
    constructor: (@playfield, @raw) ->
      @used = [
        null
        null
        null
        null
        null
        null
      ]
      @neighbors = null
      @id = @raw.id

    getNeighbors: ->
      @neighbors = @playfield.getNeighbors(this) if not @neighbors
      @neighbors

    setIncoming: (direction, state=true) ->
      ix = (hexService.labelToIndex(direction)+3) % 6
      log.debug('hex ', @id, ' incoming ', hexService.labels[ix])
      @used[ix] = state

    ###
    Mark a direction as "used", and also mark the neighbor hex as used in the correct position
    @param direction {string} the direction label (i.e. N)
    @param state {boolean} [optional] true to mark the direction "used"
    @return {boolean} true if the direction state changed
    ###
    use: (direction, state=true) ->
      ix = hexService.labelToIndex(direction)
      if @used[ix] == state
        return false
      @used[ix] = state
      log.debug('hex ', @id, ' use ', direction)

      neighbors = @getNeighbors()
      neighbors[ix].setIncoming direction, state
      @playfield.markDirty(@raw.id)
      true

    draw: (ctx) ->
      neighbors = @playfield.getNeighbors(this)
      grid = @playfield.grid
      for direction, i in @used when direction is true
        grid.drawLineBetween(ctx, @raw, neighbors[i].raw, 'black')
