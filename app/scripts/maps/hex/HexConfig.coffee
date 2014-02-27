class HexConfig
  ###
  Simple configuration object
  ###

  constructor: (
    @width = 91.14378277661477,
    @height = 91.14378277661477,
    @side = 50.0,
    @normalOrientation = true,
    @centerPoint = true,
    @drawStats = false,
    @letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ") ->

  toggleOrientation: ->
    @orientation = !@orientation

if module then module.exports = HexConfig