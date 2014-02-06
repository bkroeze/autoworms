module.exports = function(grunt) {
  'use strict';
  grunt.registerTask(
      'scripts',
      'Compiles the JavaScript files.',
      [ 'coffee:compile', 'uglify', 'clean:scripts' ]
  );
};