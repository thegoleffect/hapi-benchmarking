restify = require("restify")
fs = require("fs")

filepath = "/usr/share/dict/words"
server = restify.createServer()
server.get("/", (req, res) ->
  fs.readFile(filepath, (err, data) ->
    throw err if err
    res.send(data.toString())
  )
)

port = process.env.PORT || 3000
server.listen(port, () ->
  console.log("Listening on port #{port}")
)