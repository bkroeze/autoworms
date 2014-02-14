angular.module('autoworms').factory 'Playfield', (logger) ->
  log = logger 'Playfield'

  class Playfield
    constructor: (@grid, Location) ->
      @dirty = {}
      @locations = {}
      for raw in @grid.locations
        @locations[raw.id] = new Location(this, raw)

    draw: (canvas) ->
      log.debug 'draw'
      ctx = canvas.getContext '2d'
      for key, state of @dirty when state is true
        log.debug('drawing dirty ', key);
        @locations[key].draw ctx
      @dirty = {}

    getNeighbors: (location) ->
      points = location.raw.getNeighbors()
      locs = @grid.getLocations(points)
      return (@locations[loc.id] for loc in locs)

    markDirty: (hexId) ->
      @dirty[hexId] = true


