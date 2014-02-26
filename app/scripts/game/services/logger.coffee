angular.module('autoworms.services').service 'logger', ->

  _logger = null

  getLogger = (name, threshold, layout) ->
    if _logger is null

      if not threshold
        threshold = log4javascript.Level.DEBUG

      if not layout
        layout = new log4javascript.PatternLayout("%d{HH:mm:ss} [%c %p]: %m{4}")

      _logger = log4javascript.getRootLogger()
      appender = new log4javascript.BrowserConsoleAppender()
      appender.setLayout(layout);
      appender.setThreshold(threshold);
      _logger.addAppender(appender)

      _logger.debug('init logging');

    return log4javascript.getLogger(name)

  return getLogger
