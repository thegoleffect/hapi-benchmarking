restify = require("restify")

server = restify.createServer()
server.get("/", (req, res) ->
  res.send("Hello World.")
)

port = process.env.PORT || 3000
server.listen(port, () ->
  console.log("Listening on port #{port}")
)