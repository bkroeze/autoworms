module.exports = (grunt) ->
  "use strict"
  grunt.registerTask "dev", "Compiles things in dev/debug mode", [
    "coffeelint"
    "clean"
    "coffee:dev"
    "coffee:server"
    "jade:dev"
    "compass"
    "autoprefixer"
    "copy:buildhtml"
    "clean:buildhtml"
  ]
  return
