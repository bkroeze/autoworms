angular.module('autoworms').controller 'game', ($scope, logger, hex) ->
  log = logger 'game controller'
  log.debug 'started up'

  $scope.debugHexWH = hex.debugHexWH
  $scope.debugHexZR = hex.debugHexZR
  # $scope.getHexGridZR = hex.getHexGridZR
  $scope.getHexGridWH = hex.getHexGridWH

  $scope.changeOrientation = hex.changeOrientation

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

  log.debug 'ready'
