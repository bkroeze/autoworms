angular.module('autoworms').factory 'playfield', ($scope, $timeout, logger, hex) ->
  class Playfield
    constructor: (@grid) ->
      @hexes = {}
      for hex in @grid.hexes
        @hexes[hex.id] = new WormHex(this, hex)

    getNeighbors: (wormhex) ->
      points = wormhex.hex.getNeighbors()
      hexes = @grid.getHexes(points)
      return (@hexes[hex.id] for hex in @hexes)

      
  class WormHex
    constructor: (@playField, @hex) ->
      @used = [
        false
        false
        false
        false
        false
        false
      ]

      ###
      Mark a direction as "used", and also mark the neighbor hex as used in the correct position
      ###
      use: (direction) ->
        ix = @labels.indexOf(direction)
        @used[ix] = true

        neighbors = @playField.getNeighbors(this)
        neighbors[ix].setIncoming(direction)


  WormHex::labels = [
    'N'
    'NE'
    'SE'
    'S'
    'SW'
    'NW'
  ]