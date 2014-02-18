angular.module('autoworms').controller 'game', ($scope, $timeout, logger, hexService, Hex, Playfield, GameTimer, ChoicePulser) ->
  log = logger 'game controller'
  log.debug 'started up'

  $scope.selectedHex = 'C3'
  $scope.selectedDirection = 'N'
  $scope.selectedColor = 'red'
  $scope.directions = hexService.labels
  $scope.colors = ['black', 'red', 'green', 'blue', 'orange', 'purple', 'violet']


  ###
  Draw a line using the current settings hex and direction
  ###
  $scope.drawLine = ->
    wormHex = $scope.playfield.locations[$scope.selectedHex]
    if !wormHex
      log.debug 'Could not find hex for ', $scope.selectedHex
      return false

    wormHex.use $scope.selectedDirection,  $scope.selectedColor
    $scope.playfield.draw $scope.canvas

    # update the selectedHex with the neighbor we just moved to
    $scope.selectedHex = wormHex.getNeighbors()[hexService.labelToIndex($scope.selectedDirection)].id

  $scope.makePulser = ->
    wormHex = $scope.playfield.locations[$scope.selectedHex]
    if !wormHex
      log.debug 'Could not find hex for ', $scope.selectedHex
      return false

    ctx = $scope.canvas.getContext('2d')
    ChoicePulser.create(ctx, $scope.selectedColor, wormHex)

  $scope.showNeighbors = ->
    if !$scope.selectedHex
      log.debug 'no selected hex'
      return false
    wormHex = $scope.playfield.locations[$scope.selectedHex]
    if !wormHex
      log.debug 'Could not find hex for ', $scope.selectedHex
      return false
    ctx = $scope.canvas.getContext('2d')

    for neighbor, i in wormHex.getNeighbors()
      neighbor.raw.draw(ctx, 'blue', hexService.labels[i])


  maybeStart = ->
    log.debug 'checking for start'
    $scope.canvas = document.getElementById 'wormsCanvas'
    if $scope.canvas
      log.debug 'starting'
      grid = hexService.getHexGridWH 50, 65, $scope.canvas
      $scope.playfield = new Playfield grid, Hex
      log.debug 'Scope.grid done'
      # debugger
      # log.debug($scope.grid)
    else
      log.debug 'deferring start ...'
      $timeout maybeStart, 500

  logIt = (tick) ->
    if tick % 60 == 0
      console.log('animation timer exec! ', tick)
      return false
    true

  GameTimer.addTimers([
    {name: 'test', interval: 'animation', handlers: [logIt]}
  ])

  #GameTimer.start('test')

  maybeStart()



  log.debug 'ready'
