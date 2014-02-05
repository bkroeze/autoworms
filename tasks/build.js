module.exports = function(grunt) {
  grunt.registerTask(
      'build',
      'Compiles all of the assets and copies the files to the build directory.',
      [ 'clean:build', 'copy', 'stylesheets', 'scripts', 'jade' ]
  );
};