class Grid
  constructor: (name, @width, @height, @config, @labels) ->
    @className = name + 'Grid'
    @locations = {}

  add: (location) ->
    @locations[location.id] = location


  drawLineBetween: (ctx, locA, locB, color='black', width=2) ->
    throw 'Not Implemented'


  get: (id) ->
    for i of @locations
      return @locations[i] if @locations[i].id is id
    null


  getDistance: (locA, locB) ->
    throw 'Not Implemented'


  getLocation: (point) ->
    ###
    Returns a hex at a given point
    @this {Grid}
    @return {Location}
    ###
    point = @resolve(point)
    for h of @locations
      return @locations[h]  if @locations[h].contains(point)
    null

  getLocations: (points) ->
    ###
    Turn a list of points into a list of LOCATIONS
    @param points {Array} a list points
    @return {Array} of Locations
    ###
    locations = []

    for point in points
      #log.debug('getting hex for ' + point.x + ',' + point.y)
      locations.push(@getLocation(point))

    locations


  indexToLabel: (ix) ->
    ct = @labels.length
    while ix<0
      ix += ct

    @labels[ix % ct]


  labelToIndex: (direction) ->
    @labels.indexOf(direction);

  resolve: (point) ->
    point

if module then module.exports = Grid