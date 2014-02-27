class GridLocation
  ###
  Base class for locations on the Grid, this is the low-level interface to the actual mapping instance
  ###
  constructor: (@raw) ->
    @id = @raw.id

  contains: (point) ->
    throw 'Not Implemented'

  getNeighbors: () ->
    return @raw.getNeighbors()

module.exports = GridLocation