angular.module('autoworms.services').service 'ChoicePulser', (logger, GameTimer) ->

  log = logger('services.ChoicePulser')

  class Pulser

    @create: (ctx, color, location) ->
      p = new Pulser(ctx, color, location)
      name = 'pulser' + location.id
      GameTimer.addTimer(name, 'animation', [p.draw])
      GameTimer.start(name)

    constructor: (@ctx, @color, @location) ->
      @neighbors = @location.getNeighbors()
      @currentDirection = 0
      @started = false
      @opacity = 100
      @direction = 1
      @running = true
      @log = logger('services.ChoicePulser ' + location.id)


    draw: =>
      unless @started
        @started = true
        @log.debug('starting')

      grid = @location.playfield.grid
      # first draw the full-brightness line
      locA = @location.raw
      locB = @neighbors[@currentDirection].raw
      grid.drawLineBetween(@ctx, locA, locB, @color)

      # now draw the slightly opaque line
      grid.drawLineBetween(@ctx, locA, locB, 'rgba(0,0,0,' + (@opacity/100) + ')', 3)

      #change opacity
      if @opacity <= 0 or @opacity >= 100
        @direction *= -1

      @opacity += (5 * @direction)
      @running


    setDirection: (direction) ->
      if @started
        # clear current line
        @location.grid.drawLineBetween(@location, @neighbors[@currentDirection], 'black')

      @currentDirection = direction
      @log.debug('Change direction')

    stop: ->
      @running = false
      @log.debug('Stopping')




