module.exports = {
  build: {
    options: {
      mangle: false
    },
    files: {
      'build/scripts/application.js': [ 'build/**/*.js' ]
    }
  }
};
