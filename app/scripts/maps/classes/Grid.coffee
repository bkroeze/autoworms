class Grid
  constructor: (@width, @height, @config) ->
    @locations = []
    @labels = []


  drawLineBetween: (ctx, locA, locB, color='black', width=2) ->
    throw 'Not Implemented'


  get: (id) ->
    for i of @locations
      return @locations[i] if @locations[i].id is id
    null


  getDistance: (locA, locB) ->
    throw 'Not Implemented'


  getLocation: (point) ->
    for h of @locations
      return @locations[h]  if @locations[h].contains(p)
    null


  getLocations: (points) ->
    locations = []

    for point in points
      #log.debug('getting hex for ' + point.x + ',' + point.y)
      locations.push(@getLocation(point))

    locations


  indexToLabel: (ix) ->
    while ix<0
      ix += labels.length

    ix % labels.length

    labels[ix % labels.length]


  labelToIndex: (direction) ->
    ix = labels.indexOf(direction);
    if typeof ix == 'undefined'
      throw new Error('bad direction: ' + direction)
    ix

  resolve: (point) ->
    throw 'Not Implemented'

module.exports = Grid