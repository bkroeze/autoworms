###
A Point is simply x and y coordinates
@constructor
###
class Point
  constructor: (@x, @y) ->
    @id = @x + ':' + @y

module.exports = Point
