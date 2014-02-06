module.exports = {
  build: {
    src: [ 'build' ]
  },
  buildhtml: {
    src: [ 'build/templates' ]
  },
  stylesheets: {
    src: [ 'build/**/*.css', '!build/styles/application.css' ]
  },
  scripts: {
    src: [ 'build/**/*.js', '!build/scripts/application.js', '!build/server/**/*.js' ]
  }
};
