
class Point
  ###
  A Point is simply x and y coordinates
  @constructor
  ###
  constructor: (@x, @y) ->
    @id = @x + ':' + @y

module.exports = Point
