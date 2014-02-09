angular.module('autoworms').controller 'game', ($scope, $timeout, logger, hex) ->
  log = logger 'game controller'
  log.debug 'started up'

  # $scope.debugHexWH = hex.debugHexWH
  # $scope.debugHexZR = hex.debugHexZR
  # $scope.getHexGridZR = hex.getHexGridZR
  # $scope.getHexGridWH = hex.getHexGridWH

  $scope.changeOrientation = hex.changeOrientation

  $scope.buildDebugHexGridWH = ->
    width = parseFloat(document.getElementById("hexWidth").value)
    height = parseFloat(document.getElementById("hexHeight").value)
    canvas = document.getElementById('hexCanvas')
    hex.debugHexGridWH(width, height, canvas)

  $scope.buildDebugHexGridZR = ->
    z = parseFloat(document.getElementById("sideLength").value)
    r = parseFloat(document.getElementById("whRatio").value)
    canvas = document.getElementById('hexCanvas')
    hex.debugHexGridZR(z, r, canvas)

  $scope.buildHexGridZR = ->
    z = parseFloat(document.getElementById("sideLength").value)
    r = parseFloat(document.getElementById("whRatio").value)
    canvas = document.getElementById('hexCanvas')
    hex.getHexGridZR(z, r, canvas)

  $scope.buildHexGridWH = ->
    width = parseFloat(document.getElementById("hexWidth").value)
    height = parseFloat(document.getElementById("hexHeight").value)
    canvas = document.getElementById('hexCanvas')
    hex.getHexGridWH(width, height, canvas)

  maybeStart = ->
    log.debug 'checking for start'
    canvas = document.getElementById 'wormsCanvas'
    if canvas
      log.debug 'starting'
      hex.getHexGridWH 50, 65, canvas
    else
      log.debug 'deferring start ...'
      $timeout maybeStart, 500

  maybeStart()

  log.debug 'ready'
