module.exports = function(grunt) {
  grunt.registerTask(
    'stylesheets',
    'Compiles the stylesheets.',
    [ 'compass', 'autoprefixer', 'cssmin', 'clean:stylesheets' ]
  );
};