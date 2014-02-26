class Playfield
  constructor: (@grid, Location) ->
    @log = log4javascript.getLogger('classes.Playfield')
    @dirty = {}
    @locations = {}
    for raw in @grid.locations
      loc = new Location(this, raw)
      @locations[loc.id] = loc


  draw: (canvas) ->
    @log.debug 'draw'
    ctx = canvas.getContext '2d'
    for key, state of @dirty when state is true
      @log.debug('drawing dirty ', key);
      @locations[key].draw ctx
    @dirty = {}

  getNeighbors: (location) ->
    points = location.getNeighbors()
    locs = @grid.getLocations(points)
    (@locations[loc.id] for loc in locs)


  markDirty: (hexId) ->
    @dirty[hexId] = true

  ###
  Get the closest unused direction to the one requested, going clockwise
  ###
  resolveLegalDirection: (location, ix) ->
    neighbors = @getNeighbors(location)
    # check for any free locations
    i = 0
    free = []
    for loc in neighbors
      if location.used[i] is null
        free.push(loc)
      i++

    if free.length == 0
      throw new Error('LocationFull')

    # shortcut
    if free.length == 1
      return free[0]

    neighborCt = neighbors.length
    for i in [ix..ix+neighborCt]
      resolved = i
      while resolved<0
        resolved += neighborCt

      resolved = resolved % neighborCt

      if location.used[resolved] is null
        return resolved

    ix

module.exports = Playfield