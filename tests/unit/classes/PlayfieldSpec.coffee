Playfield = require('../../../build/scripts/classes/Playfield')
BasePlayfieldLocation = require('../../../build/scripts/classes/PlayfieldLocation')

class FakeGridLocation
  @directionCt: 4

  constructor: (x, y) ->
    @id = x + ',' + y


  getNeighbors: () ->
    []


class FakePlayfieldLocation extends BasePlayfieldLocation
  constructor: (playfield)  ->
    super(playfield, FakeGridLocation)
    @id = @raw.id

class FakeGrid
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
