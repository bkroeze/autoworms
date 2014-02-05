/**
 * grunt-express will serve the files from the folders listed in `bases`
 * on specified `port` and `hostname`
 */
module.exports = {
  dev: {
    options: {
      port: '<%= globalConfig.uniquePort  || 9000%>',
      hostname: '*',
      server: 'build',
      bases: ['.tmp','app'],
      livereload: true
      // serverreload: true
      // showStack: true
    }
  },
  test: {
    options: {
      port: '<%= globalConfig.uniquePort  || 9001%>',
      bases: ['app/tests', 'app'],
      livereload: true
    }
  }
};