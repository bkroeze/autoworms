GridLocation = require('../../../../build/scripts/maps/classes/GridLocation')

describe 'GridLocation', ->

  it 'should take the id of the base object', ->
    loc = {
      id: 'test',
      getNeighbors: -> return []
    }
    g = new GridLocation(loc)

    expect(g.id).toEqual(loc.id)

  it 'should use the base object getNeighbors function', ->
    loc = {
      id: 'test',
      getNeighbors: -> return ['a','b']
    }
    g = new GridLocation(loc)

    expect(g.getNeighbors()).toEqual(loc.getNeighbors())

  null