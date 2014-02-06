# global module:true, process:true, console:true
module.exports = (grunt) ->
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
