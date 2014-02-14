angular.module('autoworms').controller 'game', ($scope, $timeout, logger, hex, Playfield) ->
  log = logger 'game controller'
  log.debug 'started up'

  $scope.selectedHex = 'C3';
  $scope.selectedDirection = 'N';
  $scope.directions = hex.labels;


  ###
  Draw a line using the current settings hex and direction
  ###
  $scope.drawLine = ->
    if !$scope.selectedHex
      log.debug 'no selected hex'
      return false
    wormHex = $scope.playfield.hexes[$scope.selectedHex]
    if !wormHex
      log.debug 'Could not find hex for ', $scope.selectedHex
      return false

    wormHex.use $scope.selectedDirection
    $scope.playfield.draw $scope.canvas

    # update the selectedHex with the neighbor we just moved to
    $scope.selectedHex = wormHex.getNeighbors()[hex.labelToIndex($scope.selectedDirection)].id


  maybeStart = ->
    log.debug 'checking for start'
    $scope.canvas = document.getElementById 'wormsCanvas'
    if $scope.canvas
      log.debug 'starting'
      grid = hex.getHexGridWH 50, 65, $scope.canvas
      $scope.playfield = new Playfield grid
      log.debug 'Scope.grid done'
      # debugger
      # log.debug($scope.grid)
    else
      log.debug 'deferring start ...'
      $timeout maybeStart, 500

  maybeStart()



  log.debug 'ready'
