module.exports = function(grunt) {
  grunt.registerTask(
      'scripts',
      'Compiles the JavaScript files.',
      [ 'coffee', 'uglify', 'clean:scripts' ]
  );
};