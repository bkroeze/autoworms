angular.module('autoworms').controller 'game', ($scope, logger, hex) ->
  log = logger 'game controller'
  log.debug 'started up'

  $scope.debugHexWH = hex.debugHexWH
  $scope.debugHexZR = hex.debugHexZR
  $scope.getHexGridZR = hex.getHexGridZR
  $scope.getHexGridWH = hex.getHexGridWH

  log.debug 'ready'
