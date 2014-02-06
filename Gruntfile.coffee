# global module:true, process:true, console:true 
module.exports = (grunt) ->
  
  # Load grunt tasks in NPM that start with grunt-
  
  # Load grunt tasks in NPM that don't start with grunt-
  # grunt.loadNpmTasks('intern-geezer');
  # Load grunt tasks in project (including experiences generator)
  # BJK: please define all tasks in the tasks directory instead of doing them directly here
  
  # BJK: To add new sections to the config, just make a file in tasks/options
  # and it will auto-include via the code below.  This is much cleaner and easier.
  
  # load all configs found in tasks/options
  loadConfig = (path) ->
    glob = require("glob")
    object = {}
    key = undefined
    glob.sync("*",
      cwd: path
    ).forEach (option) ->
      key = option.replace(/\.js$/, "")
      object[key] = require(path + option)
      return

    object
  port = null
  if process.argv.length > 3
    port = parseInt(process.argv[3].replace("-port:", "").trim())
    console.log "Custom port argument: " + port
  require("load-grunt-tasks") grunt
  grunt.loadTasks "./tasks"
  config = {}
  config.globalConfig = uniquePort: port
  grunt.util._.extend config, loadConfig("./tasks/options/")
  grunt.initConfig config
  grunt.registerTask "default", ["build"]
  return
