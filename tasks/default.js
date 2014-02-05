module.exports = function(grunt) {
  grunt.registerTask(
      'default',
      'Watches the project for changes, automatically builds them and runs a server.',
      [ 'build', 'express', 'watch' ]
  );
};