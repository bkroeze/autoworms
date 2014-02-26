###
  Base class for locations on the Grid, this is the low-level interface to the actual mapping instance
###
class GridLocation
  constructor: (@raw) ->
    @id = @raw.id

  getNeighbors: () ->
    return @raw.getNeighbors()
