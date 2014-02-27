Grid = require('../../../../build/scripts/maps/classes/Grid.js')
GridLocation = require('../../../../build/scripts/maps/classes/GridLocation.js')
Point = require('../../../../build/scripts/maps/classes/Point.js')

class FakeLocation extends GridLocation
  contains: (point) ->
    @raw.x == point.x and @raw.y == point.y

describe 'Grid', ->
  g = null
  p1 = null
  p2 = null
  l1 = null
  l2 = null

  beforeEach ->
    g = new Grid()
    p1 = new Point(1,1)
    p2 = new Point(2,2)
    l1 = new FakeLocation(p1)
    l2 = new FakeLocation(p2)
    g.add(l1)
    g.add(l2)

  it 'should instantiate', ->
    g = new Grid()
    expect(g).toBeDefined()

  it 'should get locations', ->
    expect(g.get('1:1')).toEqual(l1)
    expect(g.get('2:2')).toEqual(l2)

  it 'should get a location by a coordinate', ->
    expect(g.getLocation(new Point(1,1))).toEqual(l1)
    expect(g.getLocation(new Point(2,2))).toEqual(l2)

  it 'should get multiple locations', ->
    expect(g.getLocations([p1,p2])).toEqual([l1,l2])

  it 'should get the correct label for various indices', ->
    g.labels = ['A','B','C','D']
    expect(g.indexToLabel(0)).toEqual('A')
    expect(g.indexToLabel(-1)).toEqual('D')
    expect(g.indexToLabel(5)).toEqual('B')

  it 'should get the correct index for a label', ->
    g.labels = ['A','B','C','D']
    expect(g.labelToIndex('A')).toEqual(0)
    expect(g.labelToIndex('B')).toEqual(1)
    expect(g.labelToIndex('D')).toEqual(3)
    expect(g.labelToIndex('XXX')).toEqual(-1)
