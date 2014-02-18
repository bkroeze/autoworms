angular.module('autoworms.services').factory 'TimerInstance', (logger, $timeout, $window) ->
  class TimerInstance
    ###
    @param name {String} name of timer
    @param interval {*} If a number, then run using timeouts at that many ms, if 'animation', then use requestAnimationFrame
    @param handlers {Array} list of handlers to attach to this timer
    ###
    constructor: (@name, @interval=null, handlers=[]) ->
      @running = false
      @handlers = []
      @timerHandle = null
      @invokeApply = true
      @log = logger('services.TimerInstance.' + @name)
      @tick = 0
      for handler in handlers
        @log.debug('adding handler')
        @addHandler(handler)


    addHandler: (handler) ->
      @handlers.push(handler)


    executeHandlers: =>
      if @running
        @startInterval()
      @tick++
      handler(@tick) for handler in @handlers


    startInterval: ->
      if @animation
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
        log.debug('Cancelling running timer')
        $timeout.cancel(@timerHandle)
      log.debug('Halted')


angular.module('autoworms.services').service 'GameTimer', (logger, TimerInstance) ->

  timers = {}
  log = logger('services.GameTimer')

  ###
  Add several timers at once
  @param timerDefs {Array} of objects with name, interval (optional) and handlers (optional)
  ###
  addTimers = (timerDefs) ->
    addTimer(t.name, t.interval, t.handlers) for t in timerDefs

  addTimer = (name, interval, handlers) ->
    if not timers[name]?
      log.debug('creating new Timer: ', name)
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
    stop: stop
  }

