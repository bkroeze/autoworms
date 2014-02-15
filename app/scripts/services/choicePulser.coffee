angular.module('autoworms.services').service 'ChoicePulser', (logger, $timeout) ->
  class Pulser
    constructor: (@color, @location, mapService) ->
      @neighbors = @location.getNeighbors()
      @currentDirection = 0
      

    draw: ->






