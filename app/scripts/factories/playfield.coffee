angular.module('autoworms').factory 'playfield', ($scope, $timeout, logger, hex) ->
  class Playfield
    constructor: (@grid) ->
      # for hex of @grid.hexes

