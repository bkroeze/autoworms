module.exports = {
  build: {
    options: {
      mangle: false
    },
    files: {
      'build/application.js': [ 'build/**/*.js' ]
    }
  }
};
