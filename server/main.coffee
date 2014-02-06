express = require("express")
app = express()
app.get "/", (req, res) ->
  res.send "hello!"
  return

module.exports = app
