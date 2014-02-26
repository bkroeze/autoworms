Worm = require('../../../build/scripts/game/classes/Worm.js')

describe 'Worm', ->
  w = null

  beforeEach ->
    w = new Worm('red')

  it 'should instantiate', ->
    expect(w).toBeDefined()

  it 'should return null if no options are available for movement', ->
    expect(w.nextMove([true])).toBeNull()

  it 'should return the first available choice if it does not know about the situation but only one exists', ->
    expect(w.nextMove([false])).toBe(0)
    expect(w.nextMove([true, false])).toBe(1)

  it 'should return available directions if it does not know about the situation and more than one exists', ->
    expect(w.nextMove([false, true, false])).toEqual([0,2])

  it 'should accept updates', ->
    used = [true, false, false]
    w.update(used, 1)
    expect(w.nextMove(used)).toBe(1)

    used = [true, true, false, false]
    w.update(used, 3)
    expect(w.nextMove(used)).toBe(3)

  null