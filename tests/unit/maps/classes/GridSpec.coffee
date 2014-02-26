Grid = require('../../../../build/scripts/maps/classes/Grid.js')

describe 'Grid', ->
  it 'should instantiate', ->
    g = new Grid()
    console.log(Grid)
    console.log(g)
    expect(g).toBeDefined()

