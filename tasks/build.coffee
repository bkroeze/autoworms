module.exports = (grunt) ->
  grunt.registerTask "build", "Compiles all of the assets and copies the files to the build directory.", [
    "coffeelint"
    "clean:build"
    "copy:build"
    "stylesheets"
    "scripts"
    "jade"
    "copy:buildhtml"
    "clean:buildhtml"
  ]
  return
