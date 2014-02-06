module.exports = (grunt) ->
  grunt.registerTask "stylesheets", "Compiles the stylesheets.", [
    "compass"
    "autoprefixer"
    "cssmin"
    "clean:stylesheets"
  ]
  return
