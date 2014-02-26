###
  Base class for locations on the playfield,  which wraps the underlying "GridLocation"
###
class PlayfieldLocation
  constructor: (@playfield, Location) ->
    @neighbors = []
    @dirty = {}
    @locations = {}
    @used = []
    for i in [0..Location.directionCt]
      @used.push(null)

  getNeighbors: () ->
    @neighbors = @playfield.getNeighbors(this) if not @neighbors
    @neighbors
