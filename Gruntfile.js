/* global module:true, process:true, console:true */
module.exports = function (grunt) {
  'use strict';
  var port = undefined;
  if (process.argv.length > 3) {
    port = parseInt(process.argv[3].replace('-port:','').trim());
    console.log('Custom port argument: ' + port);
  }

  // Load grunt tasks in NPM that start with grunt-
  require('load-grunt-tasks')(grunt);
  // Load grunt tasks in NPM that don't start with grunt-
  //grunt.loadNpmTasks('intern-geezer');
  // Load grunt tasks in project (including experiences generator)
  // BJK: please define all tasks in the tasks directory instead of doing them directly here
  grunt.loadTasks('./tasks');

  // BJK: To add new sections to the config, just make a file in tasks/options
  // and it will auto-include via the code below.  This is much cleaner and easier.
  var config = {};
  config.globalConfig = {
    uniquePort: port
  };

  // load all configs found in tasks/options
  function loadConfig(path) {
    var glob = require('glob');
    var object = {};
    var key;

    glob.sync('*',{cwd: path}).forEach(function (option) {
      key = option.replace(/\.js$/,'');
      object[key] = require(path + option);
    });

    return object;
  }

  grunt.util._.extend(config,loadConfig('./tasks/options/'));
  grunt.initConfig(config);

  grunt.registerTask('default',['build']);
};

