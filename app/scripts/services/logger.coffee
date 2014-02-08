angular.module('logger').service (name) ->
  _logger = null

  _getLogger = ->
    if _logger is null
      _logger = log4javascript.getRootLogger()
      _logger.addAppender(new log4javascript.BrowserConsoleAppender())
    return log4javascript.getLogger(name)
