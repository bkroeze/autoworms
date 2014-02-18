angular.module('autoworms.services').factory 'TimerInstance', (logger, $timeout, $window) ->
  class TimerInstance
    ###
    @param name {String} name of timer
    @param interval {*} If a number, then run using timeouts at that many ms, if 'animation', then use requestAnimationFrame
    @param handlers {Array} list of handlers to attach to this timer
    ###
    constructor: (@name, @interval, handlers) ->
      @running = false
      @handlers = []
      @timerHandle = null
      @invokeApply = true
      @log = logger('services.TimerInstance.' + @name)
      @log.debug('creating ' + @name)
      @tick = 0
      @log.debug('adding ' + handlers.length + ' handlers')
      for handler in handlers
        @log.debug('adding handler')
        @addHandler(handler)


    addHandler: (handler) ->
      @log.debug('adding handler')
      @handlers.push(handler)


    executeHandlers: =>
      if @running and @handlers.length > 0
        @startInterval()
      @tick++

      #if a handler returns false, then remove it from the next run
      nextHandlers = []

      for handler in @handlers
        if handler(@tick)
          nextHandlers.push(handler)

      @handlers = nextHandlers


    startInterval: ->
      if @interval == 'animation'
        @timerHandle = $window.requestAnimationFrame(@executeHandlers)
      else
        @timerHandle = $timeout(@executeHandlers, @interval, @invokeApply)


    start: ->
      if @interval is null
        @log.warn('no interval')
        return false

      if @timerHandle isnt null
        @log.warn('Already started')
        return true

      @running = true
      @log.debug('Starting with interval ' + @interval)
      @startInterval()
      return true


    stop: ->
      @running = false
      if @timerHandle
        @log.debug('Cancelling running timer')
        if @interval = 'animation'
          $window.cancelAnimationFrame(@timerHandle)
        else
          $timeout.cancel(@timerHandle)
      @log.debug('Halted')

timers = {}

angular.module('autoworms.services').service 'GameTimer', (TimerInstance) ->
  ###
  Add several timers at once
  @param timerDefs {Array} of objects with name, interval (optional) and handlers (optional)
  ###
  addTimers = (timerDefs) ->
    addTimer(t.name, t.interval, t.handlers) for t in timerDefs

  addTimer = (name, interval, handlers) ->
    if not timers[name]?
      timers[name] = new TimerInstance(name, interval, handlers)

    timers[name]


  get = (name) ->
    timers[name]


  start = (name) ->
    timers[name]?.start()


  stop = (name) ->
    timers[name]?.stop()


  {
    addTimers: addTimers,
    addTimer: addTimer,
    get: get,
    start: start,
    stop: stop,
    timers: timers
  }

