module.exports = {
  prod: {
    files: ['app/**/*.scss', 'app/**/*.coffee', 'app/**/*.jade'],
    tasks: ['stylesheets', 'scripts', 'jade', 'copy']
  },
  dev: {
    files: ['app/**/*.scss', 'app/**/*.coffee', 'app/**/*.jade'],
    tasks: ['dev']
  }
};