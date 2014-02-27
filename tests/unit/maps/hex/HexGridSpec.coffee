HexGrid = require('../../../../build/scripts/maps/hex/HexGrid')
HexConfig = require('../../../../build/scripts/maps/hex/HexConfig')
Point = require('../../../../build/scripts/maps/classes/Point')

describe 'HexGrid', ->

  hg = null
  cfg = new HexConfig(10, 10, 5)

  beforeEach ->
    hg = new HexGrid(100,100, cfg)

  it 'should instantiate', ->
    expect(hg).toBeDefined()

  it 'should get a location', ->
    p = new Point(5,5)
    loc = hg.getLocation(p)
    expect(loc.id).toEqual('0:0')

  it 'should calculate boundaries', ->
    expect(hg.colLimits(0)).toEqual([0,3])
    expect(hg.colLimits(1)).toEqual([1,3])