angular.module('autoworms').controller 'game', ($scope, $timeout, logger, hex, Playfield) ->
  log = logger 'game controller'
  log.debug 'started up'

  # $scope.debugHexWH = hex.debugHexWH
  # $scope.debugHexZR = hex.debugHexZR
  # $scope.getHexGridZR = hex.getHexGridZR
  # $scope.getHexGridWH = hex.getHexGridWH

  #  $scope.changeOrientation = hex.changeOrientation
  #
  #  $scope.buildDebugHexGridWH = ->
  #    width = parseFloat(document.getElementById("hexWidth").value)
  #    height = parseFloat(document.getElementById("hexHeight").value)
  #    canvas = document.getElementById('hexCanvas')
  #    hex.debugHexGridWH(width, height, canvas)
  #
  #  $scope.buildDebugHexGridZR = ->
  #    z = parseFloat(document.getElementById("sideLength").value)
  #    r = parseFloat(document.getElementById("whRatio").value)
  #    canvas = document.getElementById('hexCanvas')
  #    hex.debugHexGridZR(z, r, canvas)
  #
  #  $scope.buildHexGridZR = ->
  #    z = parseFloat(document.getElementById("sideLength").value)
  #    r = parseFloat(document.getElementById("whRatio").value)
  #    canvas = document.getElementById('hexCanvas')
  #    hex.getHexGridZR(z, r, canvas)
  #
  #  $scope.buildHexGridWH = ->
  #    width = parseFloat(document.getElementById("hexWidth").value)
  #    height = parseFloat(document.getElementById("hexHeight").value)
  #    canvas = document.getElementById('hexCanvas')
  #    hex.getHexGridWH(width, height, canvas)

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
