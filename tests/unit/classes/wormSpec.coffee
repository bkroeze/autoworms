Worm = require('../../../build/scripts/classes/worm.js')

describe 'Worm', ->
  it 'should instantiate', ->
    w = new Worm('red')
    expect(w).toBeDefined()