module.exports = (grunt) ->
  "use strict"
  grunt.registerTask "scripts", "Compiles the JavaScript files.", [
    "coffee:build"
    "uglify"
    "clean:scripts"
  ]
  return
