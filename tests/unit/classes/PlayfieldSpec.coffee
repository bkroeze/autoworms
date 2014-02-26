Playfield = require('../../../build/scripts/game/classes/Playfield')
PlayfieldLocation = require('../../../build/scripts/game/classes/PlayfieldLocation')
Grid = require('../../../build/scripts/maps/classes/Grid')

class FakeGridLocation
  @directionCt: 4

  constructor: (x, y) ->
    @id = x + ',' + y


  getNeighbors: () ->
    []


class FakePlayfieldLocation extends PlayfieldLocation
  constructor: (playfield)  ->
    super(playfield, FakeGridLocation)
    @id = @raw.id

class FakeGrid extends Grid
  constructor: (x=10, y=10) ->
    @locations = []
    for x in [0..x]
      for y in [0..y]
        location = new FakeGridLocation(x, y)
        @locations.push new FakeGridLocation(location)


  describe 'Playfield', ->
#    pf = null
#      grid = new FakeGrid()

#      beforeEach ->
#        pf = new Playfield grid, FakePlayfieldLocation

  null