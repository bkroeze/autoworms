module.exports = (grunt) ->
  "use strict"
  grunt.registerTask "dev", "Compiles things in dev/debug mode", [
    "coffeelint"
    "clean"
    "coffee:dev"
    "coffee:server"
    "copy:dev"
    "copy:devfix"
    "jade:dev"
    "compass"
    "autoprefixer"
    "copy:buildhtml"
    # "clean:buildhtml"
    "express:dev"
    # 'open:dev'
    'watch:dev'
  ]
  return
