module.exports = {
  build: {
    src: [ 'build' ]
  },
  stylesheets: {
    src: [ 'build/**/*.css', '!build/application.css' ]
  },
  scripts: {
    src: [ 'build/**/*.js', '!build/application.js' ]
  }
};
