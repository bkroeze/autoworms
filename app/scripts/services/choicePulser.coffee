angular.module('autoworms.services').service 'ChoicePulser', (logger, GameTimer) ->

  log = logger('services.ChoicePulser')

  class Pulser

    @create: (ctx, color, location, direction=1) ->
      p = new Pulser(ctx, color, location, direction)
      name = 'pulser' + location.id
      GameTimer.addTimer(name, 'animation', [p.draw])
      GameTimer.start(name)


    constructor: (@ctx, @color, @location, direction) ->
      @neighbors = @location.getNeighbors()
      @started = false
      @opacity = 100
      @running = true
      @direction = 1 # direction of opacity change
      @log = logger('services.ChoicePulser ' + location.id)
      @setDirection(direction)


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

      # @log.debug('drew ', @color, ' ', @opacity)

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
      @log.debug('Change direction to ', direction)

    stop: ->
      @running = false
      @log.debug('Stopping')




